#!/usr/bin/env python3
"""Experiment #9 mutation runner for SaturatingArithmetic.swift (Runbook v2)."""

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
SRC = ROOT / "Sources/IntegerUtilities/SaturatingArithmetic.swift"
ORIG = ROOT / "research/SaturatingArithmetic.swift.ORIG"
LOG_DIR = ROOT / "research/mutation-logs-e9"
MUT_DIR = ROOT / "research/mutants-e9"
JSONL = ROOT / "research/experiment-9-mutation-results.jsonl"

PROD_SHA = "1da0a8a5b9f7d6f9a9421786d1817b35eed7dbe9dcf48190eaac5ef131498536"
AI_SHA = "93ebec4f106534683fae2d1824c8d16bf3d5668e10b3f3a196b08f74741253a0"
AI_FILE = ROOT / "Tests/IntegerUtilitiesTests/AIGeneratedSaturatingArithmeticTests.swift"
HUMAN_FILTER = "IntegerUtilitiesTests.IntegerUtilitiesSaturatingTests"
AI_FILTER = "IntegerUtilitiesTests.AIGeneratedSaturatingArithmeticTests"
TIMEOUT = 60
REPO_SHA = "899af71c0256d0ad181e3b7eb3453c1065d928a5"
MUTANT_IDS = [f"E9-M{i:02d}" for i in range(1, 27)]


def shasum(path: Path) -> str:
    return subprocess.check_output(["shasum", "-a", "256", str(path)], text=True).split()[0]


def restore() -> None:
    shutil.copy2(ORIG, SRC)
    assert shasum(SRC) == PROD_SHA


def replace_once(text: str, old: str, new: str, label: str) -> str:
    n = text.count(old)
    if n != 1:
        raise SystemExit(f"{label}: expected 1 occurrence, found {n}\nOLD:\n{old!r}")
    return text.replace(old, new, 1)


def apply_mutant(mid: str) -> None:
    restore()
    t = SRC.read_text()

    if mid == "E9-M01":
        t = replace_once(
            t,
            "    return self < .zero ? ~.zero : .zero\n",
            "    return self <= .zero ? ~.zero : .zero\n",
            mid,
        )
    elif mid == "E9-M02":
        t = replace_once(
            t,
            "    return self < .zero ? ~.zero : .zero\n",
            "    return self < .zero ? .zero : ~.zero\n",
            mid,
        )
    elif mid == "E9-M03":
        t = replace_once(
            t,
            "    return overflow ? Self.max &- signbit : wrapped\n",
            "    return overflow ? wrapped : Self.max &- signbit\n",
            mid,
        )
    elif mid == "E9-M04":
        t = replace_once(
            t,
            "    return overflow ? Self.max &- signbit : wrapped\n",
            "    return overflow ? Self.min : wrapped\n",
            mid,
        )
    elif mid == "E9-M05":
        t = replace_once(
            t,
            "    return overflow ? Self.max &- signbit : wrapped\n",
            "    return overflow ? Self.max : wrapped\n",
            mid,
        )
    elif mid == "E9-M06":
        t = replace_once(
            t,
            "    let (wrapped, overflow) = addingReportingOverflow(other)\n",
            "    let (wrapped, overflow) = subtractingReportingOverflow(other)\n",
            mid,
        )
    elif mid == "E9-M07":
        t = replace_once(
            t,
            "    if !overflow { return wrapped }\n",
            "    if overflow { return wrapped }\n",
            mid,
        )
    elif mid == "E9-M08":
        t = replace_once(
            t,
            "    return Self.isSigned ? Self.max &- signbit : 0\n",
            "    return Self.isSigned ? Self.max &- signbit : Self.max\n",
            mid,
        )
    elif mid == "E9-M09":
        t = replace_once(
            t,
            "    return Self.isSigned ? Self.max &- signbit : 0\n",
            "    return Self.isSigned ? Self.min : 0\n",
            mid,
        )
    elif mid == "E9-M10":
        t = replace_once(
            t,
            "    let (wrapped, overflow) = subtractingReportingOverflow(other)\n",
            "    let (wrapped, overflow) = addingReportingOverflow(other)\n",
            mid,
        )
    elif mid == "E9-M11":
        t = replace_once(
            t,
            "    Self.zero.subtractingWithSaturation(self)\n",
            "    self\n",
            mid,
        )
    elif mid == "E9-M12":
        t = replace_once(
            t,
            "    if high == wrapped.signbit { return wrapped }\n",
            "    if high != wrapped.signbit { return wrapped }\n",
            mid,
        )
    elif mid == "E9-M13":
        t = replace_once(
            t,
            "    return Self.max &- high.signbit\n",
            "    return Self.max &+ high.signbit\n",
            mid,
        )
    elif mid == "E9-M14":
        t = replace_once(
            t,
            "    if high == wrapped.signbit { return wrapped }\n"
            "    return Self.max &- high.signbit\n",
            "    return wrapped\n",
            mid,
        )
    elif mid == "E9-M15":
        t = replace_once(
            t,
            "    let (high, low) = multipliedFullWidth(by: other)\n",
            "    let (high, low) = multipliedFullWidth(by: 1)\n",
            mid,
        )
    elif mid == "E9-M16":
        t = replace_once(
            t,
            "    if count == 0 { return self }\n",
            "    if count == 1 { return self }\n",
            mid,
        )
    elif mid == "E9-M17":
        t = replace_once(
            t,
            "    guard count > 0 else {\n",
            "    guard count < 0 else {\n",
            mid,
        )
    elif mid == "E9-M18":
        t = replace_once(
            t,
            "    guard count < Self.bitWidth else {\n",
            "    guard count <= Self.bitWidth else {\n",
            mid,
        )
    elif mid == "E9-M19":
        t = replace_once(
            t,
            "      return self == 0 ? 0 : clamped\n",
            "      return self == 0 ? clamped : 0\n",
            mid,
        )
    elif mid == "E9-M20":
        t = replace_once(
            t,
            "    let valueBits = Self.bitWidth &- (Self.isSigned ? 1 : 0)\n",
            "    let valueBits = Self.bitWidth &- (Self.isSigned ? 0 : 1)\n",
            mid,
        )
    elif mid == "E9-M21":
        t = replace_once(
            t,
            "    return self &>> complement == signbit ? wrapped : clamped\n",
            "    return self &>> complement == signbit ? clamped : wrapped\n",
            mid,
        )
    elif mid == "E9-M22":
        t = replace_once(
            t,
            "    let wrapped = self &<< count\n",
            "    let wrapped = self &>> count\n",
            mid,
        )
    elif mid == "E9-M23":
        t = replace_once(
            t,
            "    let complement = valueBits &- count\n",
            "    let complement = valueBits &+ count\n",
            mid,
        )
    elif mid == "E9-M24":
        t = replace_once(
            t,
            "      return shifted(\n"
            "        rightBy: count.negatedWithSaturation(),\n"
            "        rounding: rule\n"
            "      )\n",
            "      return shifted(\n"
            "        rightBy: count,\n"
            "        rounding: rule\n"
            "      )\n",
            mid,
        )
    elif mid == "E9-M25":
        t = replace_once(
            t,
            "    let clamped = Self.max &- signbit\n",
            "    let clamped = Self.max\n",
            mid,
        )
    elif mid == "E9-M26":
        t = replace_once(
            t,
            "    self.shiftedWithSaturation(leftBy: Int(clamping: count), rounding: rule)\n",
            "    self.shiftedWithSaturation(leftBy: Int(truncatingIfNeeded: count), rounding: rule)\n",
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


def run_suite(filter_expr: str, log_path: Path) -> tuple[str, float, int]:
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
