#!/usr/bin/env python3
"""Experiment #11 mutation runner (Runbook v2)."""

from __future__ import annotations

import hashlib
import json
import os
import shutil
import subprocess
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROD = ROOT / "Sources/SnapshotTesting/SnapshotTestingConfiguration.swift"
ORIG = ROOT / "research/SnapshotTestingConfiguration.swift.ORIG"
MUTANTS = ROOT / "research/mutants-e11"
LOGS = ROOT / "research/mutation-logs-e11"
RESULTS_MD = ROOT / "research/experiment-11-mutation-results.md"
RESULTS_JSONL = ROOT / "research/experiment-11-mutation-results.jsonl"

EXPECTED_PROD_SHA = "03b9c85eff3222eb65884df4ae5ea2f383385357e64ca3efe1bb48fd8fee1217"
EXPECTED_AI_SHA = "77ec567def90a1d0c4ccfe7ba12c593098494ead8065039df0906aaecf795bf9"
AI_FILE = ROOT / "Tests/SnapshotTestingTests/AIGeneratedSnapshotTestingConfigurationTests.swift"

HUMAN_FILTER = "RecordTests|WithSnapshotTestingTests"
AI_FILTER = "AIGeneratedSnapshotTestingConfigurationTests"
TIMEOUT = 60


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_suite(filter_expr: str, log_path: Path) -> tuple[str, int]:
    env = os.environ.copy()
    env["SNAPSHOT_TESTING_RECORD"] = "never"
    cmd = ["swift", "test", "--filter", filter_expr]
    try:
        p = subprocess.run(
            cmd,
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=TIMEOUT,
        )
        log_path.write_text(p.stdout + "\n" + p.stderr)
        out = p.stdout + p.stderr
        if "AIGenerated" in out and filter_expr == HUMAN_FILTER:
            if "AIGeneratedSnapshotTestingConfigurationTests" in out and "Test Case" in out:
                # Only flag if an AI test case actually started
                if "AIGeneratedSnapshotTestingConfigurationTests test" in out:
                    return "CONTAMINATED", p.returncode
        if p.returncode == 0:
            return "SURVIVED", p.returncode
        return "KILLED", p.returncode
    except subprocess.TimeoutExpired as e:
        log_path.write_text((e.stdout or b"").decode(errors="replace") + "\nTIMEOUT\n")
        return "KILLED-TIMEOUT", -1


def restore() -> None:
    shutil.copy2(ORIG, PROD)


def main() -> None:
    LOGS.mkdir(parents=True, exist_ok=True)
    assert ORIG.exists(), "missing ORIG"
    restore()
    assert sha256(PROD) == EXPECTED_PROD_SHA, "production SHA mismatch before run"
    assert sha256(AI_FILE) == EXPECTED_AI_SHA, "AI suite SHA mismatch before run"

    mutant_files = sorted(MUTANTS.glob("E11-M*.swift"))
    assert len(mutant_files) == 24, f"expected 24 mutants, got {len(mutant_files)}"

    rows = []
    with RESULTS_JSONL.open("w") as jf:
        for mf in mutant_files:
            mid = mf.stem
            restore()
            shutil.copy2(mf, PROD)
            print(f"=== {mid} ===", flush=True)

            human_log = LOGS / f"{mid}-human.log"
            ai_log = LOGS / f"{mid}-ai.log"

            h_status, h_rc = run_suite(HUMAN_FILTER, human_log)
            a_status, a_rc = run_suite(AI_FILTER, ai_log)

            restore()
            assert sha256(PROD) == EXPECTED_PROD_SHA, f"restore failed after {mid}"

            rec = {
                "id": mid,
                "human": h_status,
                "ai": a_status,
                "human_rc": h_rc,
                "ai_rc": a_rc,
                "ts": time.time(),
            }
            jf.write(json.dumps(rec) + "\n")
            jf.flush()
            rows.append(rec)
            print(rec, flush=True)

    # Scoring helpers
    def is_kill(s: str) -> bool:
        return s.startswith("KILLED")

    def is_survive(s: str) -> bool:
        return s == "SURVIVED"

    # Preliminary score (before equivalence adjudication)
    lines = [
        "# Experiment #11 — Mutation Results",
        "",
        "**Study phase:** CONFIRMATORY",
        "**Selection method:** PRE-DECLARED NEUTRAL RULE",
        "",
        "| ID | Human | AI |",
        "|---|---|---|",
    ]
    for r in rows:
        lines.append(f"| {r['id']} | {r['human']} | {r['ai']} |")

    human_kills = [r for r in rows if is_kill(r["human"])]
    ai_kills = [r for r in rows if is_kill(r["ai"])]
    human_surv = [r for r in rows if is_survive(r["human"])]
    ai_surv = [r for r in rows if is_survive(r["ai"])]
    both_kill = [r for r in rows if is_kill(r["human"]) and is_kill(r["ai"])]
    human_only = [r for r in rows if is_kill(r["human"]) and is_survive(r["ai"])]
    ai_only = [r for r in rows if is_survive(r["human"]) and is_kill(r["ai"])]
    both_surv = [r for r in rows if is_survive(r["human"]) and is_survive(r["ai"])]
    contaminated = [r for r in rows if "CONTAMINATED" in (r["human"], r["ai"])]

    lines += [
        "",
        "## Preliminary counts (before equivalence adjudication)",
        "",
        f"- Planned mutants: {len(rows)}",
        f"- Contaminated runs: {len(contaminated)} {[r['id'] for r in contaminated]}",
        f"- Human killed: {len(human_kills)}",
        f"- Human survived: {len(human_surv)}",
        f"- AI killed: {len(ai_kills)}",
        f"- AI survived: {len(ai_surv)}",
        f"- Both killed: {len(both_kill)} {[r['id'] for r in both_kill]}",
        f"- Human-only kills: {len(human_only)} {[r['id'] for r in human_only]}",
        f"- AI-only kills: {len(ai_only)} {[r['id'] for r in ai_only]}",
        f"- Both survived: {len(both_surv)} {[r['id'] for r in both_surv]}",
        "",
        "Equivalence adjudication (if any) will be appended after code-level review of shared survivors.",
        "",
    ]
    RESULTS_MD.write_text("\n".join(lines))
    print("Wrote", RESULTS_MD)


if __name__ == "__main__":
    main()
