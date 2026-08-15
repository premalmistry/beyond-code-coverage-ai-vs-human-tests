#!/usr/bin/env python3
"""Experiment #6 mutation runner for Partition.swift (Runbook v2)."""

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
SRC = ROOT / "Sources/Algorithms/Partition.swift"
ORIG = ROOT / "research/Partition.swift.ORIG"
LOG_DIR = ROOT / "research/mutation-logs-e6"
MUT_DIR = ROOT / "research/mutants-e6"
JSONL = ROOT / "research/experiment-6-mutation-results.jsonl"

PROD_SHA = "bef59fabc5958af321b728fb4bac230ff875db3135d17b6e5bee0216a8be3644"
AI_SHA = "2ed75624b2a22bf13f7911512fa3e1cf0b19385415a4d06916e8d92078725c59"
AI_FILE = ROOT / "Tests/SwiftAlgorithmsTests/AIGeneratedPartitionTests.swift"
HUMAN_FILTER = "SwiftAlgorithmsTests.PartitionTests"
AI_FILTER = "AIGeneratedPartitionTests"
TIMEOUT = 30

MUTANT_IDS = [f"E6-M{i:02d}" for i in range(1, 27)]


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

    if mid == "E6-M01":
        t = replace_once(
            t,
            "    if n == 0 { return subrange.lowerBound }\n"
            "    if n == 1 {\n",
            "    if n == 0 { return subrange.upperBound }\n"
            "    if n == 1 {\n",
            mid,
        )
    elif mid == "E6-M02":
        t = replace_once(
            t,
            "      return try belongsInSecondPartition(self[subrange.lowerBound])\n"
            "        ? subrange.lowerBound\n"
            "        : subrange.upperBound\n",
            "      return try belongsInSecondPartition(self[subrange.lowerBound])\n"
            "        ? subrange.upperBound\n"
            "        : subrange.lowerBound\n",
            mid,
        )
    elif mid == "E6-M03":
        t = replace_once(
            t,
            "    let h = n / 2\n"
            "    let i = index(subrange.lowerBound, offsetBy: h)\n",
            "    let h = n / 2 + 1\n"
            "    let i = index(subrange.lowerBound, offsetBy: h)\n",
            mid,
        )
    elif mid == "E6-M04":
        t = replace_once(
            t,
            "    let j = try stablePartition(\n"
            "      count: h,\n"
            "      subrange: subrange.lowerBound..<i,\n"
            "      by: belongsInSecondPartition)\n"
            "    let k = try stablePartition(\n"
            "      count: n - h,\n"
            "      subrange: i..<subrange.upperBound,\n"
            "      by: belongsInSecondPartition)\n",
            "    let j = try stablePartition(\n"
            "      count: n - h,\n"
            "      subrange: subrange.lowerBound..<i,\n"
            "      by: belongsInSecondPartition)\n"
            "    let k = try stablePartition(\n"
            "      count: h,\n"
            "      subrange: i..<subrange.upperBound,\n"
            "      by: belongsInSecondPartition)\n",
            mid,
        )
    elif mid == "E6-M05":
        t = replace_once(
            t,
            "    return rotate(subrange: j..<k, toStartAt: i)\n",
            "    return rotate(subrange: j..<k, toStartAt: j)\n",
            mid,
        )
    elif mid == "E6-M06":
        # MutableCollection (non-bidirectional) overload
        t = replace_once(
            t,
            "    // This version of `partition(subrange:)` is half stable; the elements in\n"
            "    // the first partition retain their original relative order.\n"
            "    guard var i = try self[subrange].firstIndex(where: belongsInSecondPartition)\n"
            "    else { return subrange.upperBound }\n",
            "    // This version of `partition(subrange:)` is half stable; the elements in\n"
            "    // the first partition retain their original relative order.\n"
            "    guard var i = try self[subrange].firstIndex(where: belongsInSecondPartition)\n"
            "    else { return subrange.lowerBound }\n",
            mid,
        )
    elif mid == "E6-M07":
        t = replace_once(
            t,
            "    while j != subrange.upperBound {\n"
            "      if try !belongsInSecondPartition(self[j]) {\n"
            "        swapAt(i, j)\n"
            "        formIndex(after: &i)\n"
            "      }\n"
            "      formIndex(after: &j)\n"
            "    }\n",
            "    while j != subrange.upperBound {\n"
            "      if try belongsInSecondPartition(self[j]) {\n"
            "        swapAt(i, j)\n"
            "        formIndex(after: &i)\n"
            "      }\n"
            "      formIndex(after: &j)\n"
            "    }\n",
            mid,
        )
    elif mid == "E6-M08":
        t = replace_once(
            t,
            "      if try !belongsInSecondPartition(self[j]) {\n"
            "        swapAt(i, j)\n"
            "        formIndex(after: &i)\n"
            "      }\n",
            "      if try !belongsInSecondPartition(self[j]) {\n"
            "        formIndex(after: &i)\n"
            "      }\n",
            mid,
        )
    elif mid == "E6-M09":
        t = replace_once(
            t,
            "      if try !belongsInSecondPartition(self[j]) {\n"
            "        swapAt(i, j)\n"
            "        formIndex(after: &i)\n"
            "      }\n",
            "      if try !belongsInSecondPartition(self[j]) {\n"
            "        swapAt(i, j)\n"
            "      }\n",
            mid,
        )
    elif mid == "E6-M10":
        t = replace_once(
            t,
            "      formIndex(after: &j)\n"
            "    }\n"
            "\n"
            "    return i\n"
            "  }\n"
            "}\n"
            "\n"
            "extension MutableCollection where Self: BidirectionalCollection {\n",
            "      formIndex(after: &j)\n"
            "    }\n"
            "\n"
            "    return j\n"
            "  }\n"
            "}\n"
            "\n"
            "extension MutableCollection where Self: BidirectionalCollection {\n",
            mid,
        )
    elif mid == "E6-M11":
        t = replace_once(
            t,
            "      FindLo: do {\n"
            "        while lo < hi {\n"
            "          if try belongsInSecondPartition(self[lo]) { break FindLo }\n"
            "          formIndex(after: &lo)\n"
            "        }\n"
            "        break Loop\n"
            "      }\n",
            "      FindLo: do {\n"
            "        while lo <= hi {\n"
            "          if try belongsInSecondPartition(self[lo]) { break FindLo }\n"
            "          formIndex(after: &lo)\n"
            "        }\n"
            "        break Loop\n"
            "      }\n",
            mid,
        )
    elif mid == "E6-M12":
        t = replace_once(
            t,
            "          if try belongsInSecondPartition(self[lo]) { break FindLo }\n",
            "          if try !belongsInSecondPartition(self[lo]) { break FindLo }\n",
            mid,
        )
    elif mid == "E6-M13":
        t = replace_once(
            t,
            "          if try !belongsInSecondPartition(self[hi]) { break FindHi }\n",
            "          if try belongsInSecondPartition(self[hi]) { break FindHi }\n",
            mid,
        )
    elif mid == "E6-M14":
        t = replace_once(
            t,
            "      swapAt(lo, hi)\n"
            "      formIndex(after: &lo)\n",
            "      formIndex(after: &lo)\n",
            mid,
        )
    elif mid == "E6-M15":
        t = replace_once(
            t,
            "      swapAt(lo, hi)\n"
            "      formIndex(after: &lo)\n",
            "      swapAt(lo, hi)\n",
            mid,
        )
    elif mid == "E6-M16":
        t = replace_once(
            t,
            "      formIndex(after: &lo)\n"
            "    }\n"
            "\n"
            "    return lo\n"
            "  }\n"
            "}\n"
            "\n"
            "//===----------------------------------------------------------------------===//\n"
            "// partitioningIndex(where:)\n",
            "      formIndex(after: &lo)\n"
            "    }\n"
            "\n"
            "    return hi\n"
            "  }\n"
            "}\n"
            "\n"
            "//===----------------------------------------------------------------------===//\n"
            "// partitioningIndex(where:)\n",
            mid,
        )
    elif mid == "E6-M17":
        t = replace_once(
            t,
            "    while n > 0 {\n"
            "      let half = n / 2\n",
            "    while n > 1 {\n"
            "      let half = n / 2\n",
            mid,
        )
    elif mid == "E6-M18":
        t = replace_once(
            t,
            "      let half = n / 2\n"
            "      let mid = index(l, offsetBy: half)\n",
            "      let half = (n + 1) / 2\n"
            "      let mid = index(l, offsetBy: half)\n",
            mid,
        )
    elif mid == "E6-M19":
        t = replace_once(
            t,
            "      if try belongsInSecondPartition(self[mid]) {\n"
            "        n = half\n"
            "      } else {\n"
            "        l = index(after: mid)\n"
            "        n -= half + 1\n"
            "      }\n",
            "      if try belongsInSecondPartition(self[mid]) {\n"
            "        l = index(after: mid)\n"
            "        n -= half + 1\n"
            "      } else {\n"
            "        n = half\n"
            "      }\n",
            mid,
        )
    elif mid == "E6-M20":
        t = replace_once(
            t,
            "        l = index(after: mid)\n"
            "        n -= half + 1\n",
            "        l = index(after: mid)\n"
            "        n -= half\n",
            mid,
        )
    elif mid == "E6-M21":
        t = replace_once(
            t,
            "    for element in self {\n"
            "      if try predicate(element) {\n"
            "        rhs.append(element)\n"
            "      } else {\n"
            "        lhs.append(element)\n"
            "      }\n"
            "    }\n"
            "\n"
            "    return (lhs, rhs)\n",
            "    for element in self {\n"
            "      if try predicate(element) {\n"
            "        lhs.append(element)\n"
            "      } else {\n"
            "        rhs.append(element)\n"
            "      }\n"
            "    }\n"
            "\n"
            "    return (lhs, rhs)\n",
            mid,
        )
    elif mid == "E6-M22":
        t = replace_once(
            t,
            "    guard !self.isEmpty else {\n"
            "      return ([], [])\n"
            "    }\n"
            "\n"
            "    // Since collections have known sizes, we can allocate one array of size\n",
            "    // Since collections have known sizes, we can allocate one array of size\n",
            mid,
        )
    elif mid == "E6-M23":
        t = replace_once(
            t,
            "          for element in self {\n"
            "            if try predicate(element) {\n"
            "              rhs -= 1\n"
            "              rhs.initialize(to: element)\n"
            "            } else {\n"
            "              lhs.initialize(to: element)\n"
            "              lhs += 1\n"
            "            }\n"
            "          }\n",
            "          for element in self {\n"
            "            if try predicate(element) {\n"
            "              lhs.initialize(to: element)\n"
            "              lhs += 1\n"
            "            } else {\n"
            "              rhs -= 1\n"
            "              rhs.initialize(to: element)\n"
            "            }\n"
            "          }\n",
            mid,
        )
    elif mid == "E6-M24":
        t = replace_once(
            t,
            "          let rhsIndex = rhs - bufferStart\n"
            "          buffer[rhsIndex...].reverse()\n"
            "          initializedCount = buffer.count\n",
            "          let rhsIndex = rhs - bufferStart\n"
            "          initializedCount = buffer.count\n",
            mid,
        )
    elif mid == "E6-M25":
        t = replace_once(
            t,
            "          midPoint = rhsIndex\n",
            "          midPoint = 0\n",
            mid,
        )
    elif mid == "E6-M26":
        t = replace_once(
            t,
            "    for element in self {\n"
            "      if try predicate(element) {\n"
            "        rhs.append(element)\n"
            "      } else {\n"
            "        lhs.append(element)\n"
            "      }\n"
            "    }\n"
            "\n"
            "    return (lhs, rhs)\n",
            "    for element in self {\n"
            "      if try predicate(element) {\n"
            "        rhs.append(element)\n"
            "      } else {\n"
            "        lhs.append(element)\n"
            "      }\n"
            "    }\n"
            "\n"
            "    return (rhs, lhs)\n",
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
        if any(
            m in text
            for m in (
                "fatal error",
                "precondition failure",
                "illegal instruction",
                "caught signal",
                "exited with unexpected signal",
            )
        ) and not re.search(r"executed \d+ tests, with [1-9]\d* failures", text):
            # Prefer crash when no XCTest failure count, or signal abort
            if "exited with unexpected signal" in text or "fatal error" in text or "precondition failure" in text:
                if "xctassertequal failed" not in text and "error: -[" not in text:
                    return "KILLED-CRASH"
        if "error:" in text and "failed to build" in text or "error: emit-module" in text:
            return "INVALID"
        if "error:" in text and "compiling" in text and "executed" not in text:
            return "INVALID"
        return "KILLED"
    return "SURVIVED"


def extract_test_names(output: str) -> list[str]:
    return re.findall(r"Test Case '(-\[SwiftAlgorithmsTests\.[^\]]+\])'", output)


def run_suite(filter_expr: str, log_path: Path, expect_ai: bool) -> tuple[str, float, int, bool]:
    """Returns outcome, elapsed, rc, contaminated."""
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

    names = extract_test_names(out)
    contaminated = False
    if expect_ai:
        if any("AIGenerated" not in n and "PartitionTests" in n for n in names):
            # Human PartitionTests mixed into AI run
            contaminated = True
    else:
        if any("AIGenerated" in n for n in names):
            contaminated = True

    if contaminated:
        return "CONTAMINATED", elapsed, rc, True

    outcome = classify(rc, out, timed_out)
    return outcome, elapsed, rc, False


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

    if not only:
        JSONL.write_text("")

    for mid in ids:
        print(f"=== {mid} ===", flush=True)
        apply_mutant(mid)
        human, h_t, h_rc, h_cont = run_suite(
            HUMAN_FILTER, LOG_DIR / f"{mid}-human.log", expect_ai=False
        )
        ai, a_t, a_rc, a_cont = run_suite(
            AI_FILTER, LOG_DIR / f"{mid}-ai.log", expect_ai=True
        )
        restore()
        row = {
            "id": mid,
            "human": human,
            "ai": ai,
            "human_seconds": round(h_t, 3),
            "ai_seconds": round(a_t, 3),
            "human_rc": h_rc,
            "ai_rc": a_rc,
            "human_contaminated": h_cont,
            "ai_contaminated": a_cont,
        }
        with JSONL.open("a") as f:
            f.write(json.dumps(row) + "\n")
        print(json.dumps(row), flush=True)
        if h_cont or a_cont:
            raise SystemExit(f"CONTAMINATED run for {mid}; aborting")

    restore()
    print("DONE", len(ids), "mutants", flush=True)


if __name__ == "__main__":
    main()
