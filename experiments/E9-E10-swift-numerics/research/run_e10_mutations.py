#!/usr/bin/env python3
"""Experiment #10 mutation runner for Polar.swift (Runbook v2)."""

from __future__ import annotations

import json
import os
import re
import shutil
import signal
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "Sources/ComplexModule/Polar.swift"
ORIG = ROOT / "research/Polar.swift.ORIG"
LOG_DIR = ROOT / "research/mutation-logs-e10"
MUT_DIR = ROOT / "research/mutants-e10"
JSONL = ROOT / "research/experiment-10-mutation-results.jsonl"

PROD_SHA = "d7c8056e0014a70367480efe161c64fb4bc525047a8681cf2fdba8be192e68d4"
AI_SHA = "b8eb9d8ca821b9bd0e74d30509135ea852c8b3b8397a57a5cc53995739bbf7fe"
AI_FILE = ROOT / "Tests/ComplexTests/AIGeneratedPolarTests.swift"
HUMAN_FILTER = "ComplexTests.ArithmeticTests/testPolar"
AI_FILTER = "ComplexTests.AIGeneratedPolarTests"
TIMEOUT = 60
REPO_SHA = "899af71c0256d0ad181e3b7eb3453c1065d928a5"
MUTANT_IDS = [f"E10-M{i:02d}" for i in range(1, 25)]


def shasum(path: Path) -> str:
    return subprocess.check_output(["shasum", "-a", "256", str(path)], text=True).split()[0]


def restore() -> None:
    shutil.copy2(ORIG, SRC)
    assert shasum(SRC) == PROD_SHA


def invalidate_inlined_build() -> None:
    """Polar APIs are @_transparent/@inlinable; clean so mutants/restores take effect."""
    subprocess.run(
        ["swift", "package", "clean"],
        cwd=ROOT,
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def replace_once(text: str, old: str, new: str, label: str) -> str:
    n = text.count(old)
    if n != 1:
        raise SystemExit(f"{label}: expected 1 occurrence, found {n}\nOLD:\n{old!r}")
    return text.replace(old, new, 1)


def apply_mutant(mid: str) -> None:
    restore()
    t = SRC.read_text()

    if mid == "E10-M01":
        t = replace_once(
            t,
            "    guard naive.isNormal else { return carefulLength }\n",
            "    guard !naive.isNormal else { return carefulLength }\n",
            mid,
        )
    elif mid == "E10-M02":
        t = replace_once(
            t,
            "    guard naive.isNormal else { return carefulLength }\n",
            "    guard naive.isNormal else { return naive }\n",
            mid,
        )
    elif mid == "E10-M03":
        t = replace_once(
            t,
            "    return .sqrt(naive)\n",
            "    return naive\n",
            mid,
        )
    elif mid == "E10-M04":
        t = replace_once(
            t,
            "    return .sqrt(naive)\n",
            "    return .sqrt(naive / 2)\n",
            mid,
        )
    elif mid == "E10-M05":
        t = replace_once(
            t,
            "    guard isFinite else { return .infinity }\n",
            "    guard !isFinite else { return .infinity }\n",
            mid,
        )
    elif mid == "E10-M06":
        t = replace_once(
            t,
            "    guard isFinite else { return .infinity }\n",
            "    guard isFinite else { return .zero }\n",
            mid,
        )
    elif mid == "E10-M07":
        t = replace_once(
            t,
            "    return .hypot(x, y)\n",
            "    return .sqrt(x*x + y*y)\n",
            mid,
        )
    elif mid == "E10-M08":
        t = replace_once(
            t,
            "    x*x + y*y\n",
            "    x*x - y*y\n",
            mid,
        )
    elif mid == "E10-M09":
        t = replace_once(
            t,
            "    x*x + y*y\n",
            "    x*x\n",
            mid,
        )
    elif mid == "E10-M10":
        t = replace_once(
            t,
            "    guard isFinite && !isZero else { return .nan }\n",
            "    guard isFinite || !isZero else { return .nan }\n",
            mid,
        )
    elif mid == "E10-M11":
        t = replace_once(
            t,
            "    guard isFinite && !isZero else { return .nan }\n",
            "    guard isFinite && isZero else { return .nan }\n",
            mid,
        )
    elif mid == "E10-M12":
        t = replace_once(
            t,
            "    guard isFinite && !isZero else { return .nan }\n",
            "    guard isFinite && !isZero else { return .zero }\n",
            mid,
        )
    elif mid == "E10-M13":
        t = replace_once(
            t,
            "    return .atan2(y: y, x: x)\n",
            "    return .atan2(y: x, x: y)\n",
            mid,
        )
    elif mid == "E10-M14":
        t = replace_once(
            t,
            "    (length, phase)\n",
            "    (length: phase, phase: length)\n",
            mid,
        )
    elif mid == "E10-M15":
        t = replace_once(
            t,
            "    if phase.isFinite {\n",
            "    if !phase.isFinite {\n",
            mid,
        )
    elif mid == "E10-M16":
        t = replace_once(
            t,
            "      self = Complex(.cos(phase), .sin(phase)).multiplied(by: length)\n",
            "      self = Complex(.sin(phase), .cos(phase)).multiplied(by: length)\n",
            mid,
        )
    elif mid == "E10-M17":
        t = replace_once(
            t,
            "      self = Complex(.cos(phase), .sin(phase)).multiplied(by: length)\n",
            "      self = Complex(.cos(phase), .sin(phase)).divided(by: length)\n",
            mid,
        )
    elif mid == "E10-M18":
        t = replace_once(
            t,
            "      self = Complex(.cos(phase), .sin(phase)).multiplied(by: length)\n",
            "      self = Complex(.cos(phase), .sin(phase)).multiplied(by: -length)\n",
            mid,
        )
    elif mid == "E10-M19":
        t = replace_once(
            t,
            "        length.isZero || length.isInfinite,\n",
            "        length.isZero && length.isInfinite,\n",
            mid,
        )
    elif mid == "E10-M20":
        t = replace_once(
            t,
            "      self = Complex(length)\n",
            "      self = Complex(-length)\n",
            mid,
        )
    elif mid == "E10-M21":
        t = replace_once(
            t,
            "      precondition(\n"
            "        length.isZero || length.isInfinite,\n"
            "        \"Either phase must be finite, or length must be zero or infinite.\"\n"
            "      )\n"
            "      self = Complex(length)\n",
            "      self = Complex(length)\n",
            mid,
        )
    elif mid == "E10-M22":
        t = replace_once(
            t,
            "    let naive = lengthSquared\n"
            "    guard naive.isNormal else { return carefulLength }\n"
            "    return .sqrt(naive)\n",
            "    let naive = lengthSquared\n"
            "    return .sqrt(naive)\n",
            mid,
        )
    elif mid == "E10-M23":
        t = replace_once(
            t,
            "    return .atan2(y: y, x: x)\n",
            "    return -.atan2(y: y, x: x)\n",
            mid,
        )
    elif mid == "E10-M24":
        t = replace_once(
            t,
            "    guard isFinite else { return .infinity }\n",
            "    guard isFinite else { return .nan }\n",
            mid,
        )
    else:
        raise SystemExit(f"unknown mutant {mid}")

    SRC.write_text(t)
    shutil.copy2(SRC, MUT_DIR / f"{mid}.swift")


def classify(returncode: int, output: str, timed_out: bool) -> str:
    if timed_out:
        return "KILLED-TIMEOUT"
    text = output.lower()
    if returncode != 0:
        crash_markers = (
            "fatal error",
            "precondition",
            "assertion failed",
            "fatalerror",
            "exc_bad",
            "trap",
            "signal",
            "illegal instruction",
            "segfault",
        )
        if any(m in text for m in crash_markers) and "failed" not in text.split("test case")[0][-200:]:
            if "xctassert" not in text and "failed (" not in text:
                if any(m in text for m in ("fatal error", "precondition failure", "illegal instruction")):
                    return "KILLED-CRASH"
        if "failed" in text or returncode != 0:
            if any(
                m in text
                for m in (
                    "fatal error",
                    "precondition failure",
                    "illegal instruction",
                    "caught signal",
                )
            ) and "with 0 failures" in text:
                return "KILLED-CRASH"
            if any(
                m in text
                for m in (
                    "fatal error",
                    "precondition failure",
                    "illegal instruction",
                    "caught signal",
                )
            ) and not re.search(r"executed \d+ tests, with [1-9]", text):
                return "KILLED-CRASH"
            return "KILLED"
    if "with 0 failures" in text or "executed" in text:
        return "SURVIVED"
    return "SURVIVED"


def run_suite_once(
    filter_expr: str, log_path: Path, *, clean: bool = True
) -> tuple[str, float, int]:
    if clean:
        invalidate_inlined_build()
    cmd = ["swift", "test", "--filter", filter_expr]
    t0 = time.time()
    timed_out = False
    proc = subprocess.Popen(
        cmd,
        cwd=ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        start_new_session=True,
    )
    try:
        out, _ = proc.communicate(timeout=TIMEOUT)
        rc = proc.returncode
    except subprocess.TimeoutExpired:
        timed_out = True
        try:
            os.killpg(proc.pid, signal.SIGKILL)
        except Exception:
            proc.kill()
        out, _ = proc.communicate()
        rc = -9
    elapsed = time.time() - t0
    out = out or ""
    log_path.write_text(out)
    outcome = classify(rc, out, timed_out)
    return outcome, elapsed, rc


def run_suite(filter_expr: str, log_path: Path) -> tuple[str, float, int]:
    """Human testPolar uses RNG; require 3 consecutive kills to avoid flakes."""
    is_human = "AIGenerated" not in filter_expr
    retries = 3 if is_human else 1
    total_t = 0.0
    last_rc = 0
    last_outcome = "SURVIVED"
    for i in range(retries):
        path = log_path if retries == 1 else log_path.with_name(
            log_path.stem + f"-try{i+1}" + log_path.suffix
        )
        # Clean only on first try; mutant source unchanged across Human retries.
        outcome, elapsed, rc = run_suite_once(filter_expr, path, clean=(i == 0))
        total_t += elapsed
        last_rc = rc
        last_outcome = outcome
        if is_human and outcome == "SURVIVED":
            log_path.write_text(
                f"HUMAN_STABLE_SURVIVED after try {i+1}\n" + path.read_text()
            )
            return "SURVIVED", total_t, rc
    if is_human and last_outcome.startswith("KILLED"):
        parts = []
        for i in range(retries):
            p = log_path.with_name(log_path.stem + f"-try{i+1}" + log_path.suffix)
            if p.exists():
                parts.append(f"===== TRY {i+1} =====\n" + p.read_text())
        log_path.write_text("\n".join(parts))
    return last_outcome, total_t, last_rc


def integrity_preflight() -> None:
    assert shasum(SRC) == PROD_SHA, "production SHA mismatch before run"
    assert shasum(AI_FILE) == AI_SHA, "AI test SHA mismatch before run"
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
    assert head == REPO_SHA, f"repo SHA {head}"


def main() -> None:
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    MUT_DIR.mkdir(parents=True, exist_ok=True)
    only = sys.argv[1:]
    ids = only if only else MUTANT_IDS

    integrity_preflight()
    restore()

    if not only:
        JSONL.write_text("")

    results = []
    for mid in ids:
        print(f"=== {mid} ===", flush=True)
        apply_mutant(mid)
        human, h_t, h_rc = run_suite(HUMAN_FILTER, LOG_DIR / f"{mid}-human.log")
        ai, a_t, a_rc = run_suite(AI_FILTER, LOG_DIR / f"{mid}-ai.log")
        restore()
        row = {
            "id": mid,
            "human": human,
            "ai": ai,
            "human_seconds": round(h_t, 3),
            "ai_seconds": round(a_t, 3),
            "human_rc": h_rc,
            "ai_rc": a_rc,
        }
        results.append(row)
        with JSONL.open("a") as f:
            f.write(json.dumps(row) + "\n")
        print(json.dumps(row), flush=True)

    restore()
    print("DONE", len(results), "mutants", flush=True)


if __name__ == "__main__":
    main()
