#!/usr/bin/env python3
"""Experiment #5 mutation runner for Combinations.swift."""

from __future__ import annotations

import json
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "Sources/Algorithms/Combinations.swift"
ORIG = ROOT / "research/Combinations.swift.ORIG"
LOG_DIR = ROOT / "research/mutation-logs-e5"
MUT_DIR = ROOT / "research/mutants-e5"
JSONL = ROOT / "research/experiment-5-mutation-results.jsonl"

PROD_SHA = "a47a9033683f9be178ebd992398c1bc7c4f269c2eb02c2ac34cc7d3bd4dc2263"
AI_SHA = "e976602ed1a9a7546365a77dce298e130cee68d9645f8088bb7cdc8b52e529fa"
AI_FILE = ROOT / "Tests/SwiftAlgorithmsTests/AIGeneratedCombinationsTests.swift"
# Precise class filter — bare "CombinationsTests" also matches AIGeneratedCombinationsTests.
HUMAN_FILTER = "SwiftAlgorithmsTests.CombinationsTests"
AI_FILTER = "AIGeneratedCombinationsTests"
TIMEOUT = 30

MUTANT_IDS = [f"E5-M{i:02d}" for i in range(1, 27)]


def shasum(path: Path) -> str:
    out = subprocess.check_output(["shasum", "-a", "256", str(path)], text=True)
    return out.split()[0]


def restore() -> None:
    shutil.copy2(ORIG, SRC)
    assert shasum(SRC) == PROD_SHA, "production SHA mismatch after restore"


def replace_once(text: str, old: str, new: str, label: str) -> str:
    n = text.count(old)
    if n != 1:
        raise SystemExit(f"{label}: expected 1 occurrence, found {n}\nOLD:\n{old!r}")
    return text.replace(old, new, 1)


def apply_mutant(mid: str) -> None:
    restore()
    t = SRC.read_text()

    if mid == "E5-M01":
        t = replace_once(
            t,
            "    self.kRange =\n"
            "      range.lowerBound < upperBound\n"
            "      ? range.clamped(to: 0..<upperBound)\n"
            "      : nil",
            "    self.kRange =\n"
            "      range.lowerBound <= upperBound\n"
            "      ? range.clamped(to: 0..<upperBound)\n"
            "      : nil",
            mid,
        )
    elif mid == "E5-M02":
        t = replace_once(
            t,
            "      ? range.clamped(to: 0..<upperBound)\n",
            "      ? range.clamped(to: 0..<(upperBound - 1))\n",
            mid,
        )
    elif mid == "E5-M03":
        t = replace_once(
            t,
            "    self.kRange =\n"
            "      range.lowerBound < upperBound\n"
            "      ? range.clamped(to: 0..<upperBound)\n"
            "      : nil",
            "    self.kRange =\n"
            "      range.lowerBound < upperBound\n"
            "      ? range.clamped(to: 0..<upperBound)\n"
            "      : 0..<0",
            mid,
        )
    elif mid == "E5-M04":
        t = replace_once(
            t,
            "    guard let k = self.kRange else { return 0 }\n",
            "    guard let k = self.kRange else { return 1 }\n",
            mid,
        )
    elif mid == "E5-M05":
        t = replace_once(
            t,
            "    if k == 0..<(n + 1) {\n",
            "    if k == 0..<n {\n",
            mid,
        )
    elif mid == "E5-M06":
        t = replace_once(
            t,
            "      return 1 << n\n",
            "      return 1 << (n - 1)\n",
            mid,
        )
    elif mid == "E5-M07":
        t = replace_once(
            t,
            "      case n, 0: return 1\n",
            "      case n, 0: return 0\n",
            mid,
        )
    elif mid == "E5-M08":
        t = replace_once(
            t,
            "      case n...: return 0\n",
            "      case n...: return 1\n",
            mid,
        )
    elif mid == "E5-M09":
        t = replace_once(
            t,
            "      case (n / 2 + 1)...: return binomial(n: n, k: n - k)\n",
            "      case (n / 2 + 1)...: return binomial(n: n, k: k - 1)\n",
            mid,
        )
    elif mid == "E5-M10":
        t = replace_once(
            t,
            "      default: return n * binomial(n: n - 1, k: k - 1) / k\n",
            "      default: return n + binomial(n: n - 1, k: k - 1) / k\n",
            mid,
        )
    elif mid == "E5-M11":
        t = replace_once(
            t,
            "    return k.map {\n"
            "      binomial(n: n, k: $0)\n"
            "    }.reduce(0, +)\n",
            "    return k.map {\n"
            "      binomial(n: n, k: $0)\n"
            "    }.reduce(1, *)\n",
            mid,
        )
    elif mid == "E5-M12":
        t = replace_once(
            t,
            "    internal var isFinished: Bool {\n"
            "      kRange.isEmpty\n"
            "    }\n",
            "    internal var isFinished: Bool {\n"
            "      !kRange.isEmpty\n"
            "    }\n",
            mid,
        )
    elif mid == "E5-M13":
        t = replace_once(
            t,
            "      self.kRange = combinations.kRange ?? 0..<0\n",
            "      self.kRange = combinations.kRange ?? 0..<1\n",
            mid,
        )
    elif mid == "E5-M14":
        t = replace_once(
            t,
            "      self.indexes = Array(combinations.base.indices.prefix(kRange.lowerBound))\n",
            "      self.indexes = Array(combinations.base.indices.prefix(kRange.lowerBound + 1))\n",
            mid,
        )
    elif mid == "E5-M15":
        t = replace_once(
            t,
            "        if kRange.lowerBound < kRange.upperBound {\n"
            "          let advancedLowerBound = kRange.lowerBound + 1\n",
            "        if kRange.lowerBound <= kRange.upperBound {\n"
            "          let advancedLowerBound = kRange.lowerBound + 1\n",
            mid,
        )
    elif mid == "E5-M16":
        t = replace_once(
            t,
            "          let advancedLowerBound = kRange.lowerBound + 1\n",
            "          let advancedLowerBound = kRange.lowerBound + 2\n",
            mid,
        )
    elif mid == "E5-M17":
        t = replace_once(
            t,
            "          indexes.append(contentsOf: base.indices.prefix(kRange.lowerBound))\n",
            "          indexes.append(contentsOf: base.indices.prefix(kRange.upperBound))\n",
            mid,
        )
    elif mid == "E5-M18":
        t = replace_once(
            t,
            "      guard !indexes.isEmpty else {\n",
            "      guard indexes.isEmpty else {\n",
            mid,
        )
    elif mid == "E5-M19":
        t = replace_once(
            t,
            "      let i = indexes.count - 1\n"
            "      base.formIndex(after: &indexes[i])\n"
            "      if indexes[i] != base.endIndex { return }\n",
            "      let i = indexes.count - 1\n"
            "      base.formIndex(before: &indexes[i])\n"
            "      if indexes[i] != base.endIndex { return }\n",
            mid,
        )
    elif mid == "E5-M20":
        t = replace_once(
            t,
            "      if indexes[i] != base.endIndex { return }\n",
            "      if indexes[i] == base.endIndex { return }\n",
            mid,
        )
    elif mid == "E5-M21":
        t = replace_once(
            t,
            "        guard j >= 0 else {\n",
            "        guard j > 0 else {\n",
            mid,
        )
    elif mid == "E5-M22":
        t = replace_once(
            t,
            "          indexes[k] = base.index(after: indexes[k - 1])\n",
            "          indexes[k] = indexes[k - 1]\n",
            mid,
        )
    elif mid == "E5-M23":
        t = replace_once(
            t,
            "          if indexes[k] == base.endIndex {\n"
            "            break\n"
            "          }\n",
            "          if indexes[k] != base.endIndex {\n"
            "            break\n"
            "          }\n",
            mid,
        )
    elif mid == "E5-M24":
        t = replace_once(
            t,
            "      guard !isFinished else { return nil }\n",
            "      guard isFinished else { return nil }\n",
            mid,
        )
    elif mid == "E5-M25":
        t = replace_once(
            t,
            "      guard !isFinished else { return nil }\n"
            "      defer { advance() }\n"
            "      return indexes.map { i in base[i] }\n",
            "      guard !isFinished else { return nil }\n"
            "      return indexes.map { i in base[i] }\n",
            mid,
        )
    elif mid == "E5-M26":
        t = replace_once(
            t,
            "    precondition(\n"
            "      k >= 0,\n"
            "      \"Can't have combinations with a negative number of elements.\")\n",
            "    precondition(\n"
            "      k > 0,\n"
            "      \"Can't have combinations with a negative number of elements.\")\n",
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
            # Prefer crash if clearly a runtime abort without XCTest failures listed
            if "xctassert" not in text and "failed (" not in text:
                if any(m in text for m in ("fatal error", "precondition failure", "illegal instruction")):
                    return "KILLED-CRASH"
        # Standard test failure
        if "failed" in text or returncode != 0:
            # Distinguish crash-like exits
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
    # returncode 0
    if "with 0 failures" in text or "executed" in text:
        return "SURVIVED"
    return "SURVIVED"


def run_suite(filter_expr: str, log_path: Path) -> tuple[str, float, int]:
    import os
    import signal

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


def _decode(blob) -> str:
    if blob is None:
        return ""
    if isinstance(blob, bytes):
        return blob.decode("utf-8", errors="replace")
    return blob


def integrity_preflight() -> None:
    assert shasum(SRC) == PROD_SHA, "production SHA mismatch before run"
    assert shasum(AI_FILE) == AI_SHA, "AI test SHA mismatch before run"
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
    assert head == "5b7143f8e291dee0e14c118fd0212487f0b37af5", f"repo SHA {head}"


def main() -> None:
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    MUT_DIR.mkdir(parents=True, exist_ok=True)
    only = sys.argv[1:]
    ids = only if only else MUTANT_IDS

    integrity_preflight()
    restore()

    # Truncate jsonl if full run
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
