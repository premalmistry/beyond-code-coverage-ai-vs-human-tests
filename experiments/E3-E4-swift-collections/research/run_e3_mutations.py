#!/usr/bin/env python3
"""Experiment #3 mutation runner. Applies one mutant at a time; restores after each."""

from __future__ import annotations

import json
import os
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HANDLE = ROOT / "Sources/HeapModule/Heap+UnsafeHandle.swift"
NODE = ROOT / "Sources/HeapModule/_HeapNode.swift"
HANDLE_ORIG = ROOT / "research/Heap+UnsafeHandle.swift.ORIG"
NODE_ORIG = ROOT / "research/_HeapNode.swift.ORIG"
LOG_DIR = ROOT / "research/mutation-logs-e3"
MUT_DIR = ROOT / "research/mutants-e3"
JSONL = ROOT / "research/mutation-results-e3.jsonl"

HANDLE_SHA = "c610016a3f2601a2cc6466f90ba05a843d219490ea994421f77bb56bceda2270"
NODE_SHA = "0cc99c47754521861147d543d6ebd868ef7109296b9cb005c9c50bf471346736"

HUMAN_FILTER = "HeapTests.HeapTests|HeapNodeTests"
AI_FILTER = "AIGeneratedHeapTests"
DEFAULT_TIMEOUT = 120
HANG_TIMEOUT = 45  # for E3-M26


def shasum(path: Path) -> str:
    out = subprocess.check_output(["shasum", "-a", "256", str(path)], text=True)
    return out.split()[0]


def restore() -> None:
    shutil.copy2(HANDLE_ORIG, HANDLE)
    shutil.copy2(NODE_ORIG, NODE)
    assert shasum(HANDLE) == HANDLE_SHA, "handle SHA mismatch after restore"
    assert shasum(NODE) == NODE_SHA, "node SHA mismatch after restore"


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"{label}: expected exactly 1 occurrence of old snippet, found {count}")
    return text.replace(old, new, 1)


def apply_mutant(mid: str) -> Path:
    """Apply mutant; return path of mutated primary file used."""
    restore()
    h = HANDLE.read_text()
    n = NODE.read_text()
    target = HANDLE

    if mid == "E3-M01":
        h = replace_once(
            h,
            "    self[b] < self[a] ? b : a",
            "    self[b] > self[a] ? b : a",
            mid,
        )
    elif mid == "E3-M02":
        h = replace_once(
            h,
            "    self[b] < self[a] ? b : a",
            "    self[b] <= self[a] ? b : a",
            mid,
        )
    elif mid == "E3-M03":
        h = replace_once(
            h,
            "    self[b] >= self[a] ? b : a",
            "    self[b] < self[a] ? b : a",
            mid,
        )
    elif mid == "E3-M04":
        h = replace_once(
            h,
            "    self[b] >= self[a] ? b : a",
            "    self[b] > self[a] ? b : a",
            mid,
        )
    elif mid == "E3-M05":
        h = replace_once(
            h,
            "    if (node.isMinLevel && self[node] > self[parent])\n"
            "        || (!node.isMinLevel && self[node] < self[parent]){",
            "    if (node.isMinLevel && self[node] < self[parent])\n"
            "        || (!node.isMinLevel && self[node] < self[parent]){",
            mid,
        )
    elif mid == "E3-M06":
        h = replace_once(
            h,
            "    if (node.isMinLevel && self[node] > self[parent])\n"
            "        || (!node.isMinLevel && self[node] < self[parent]){",
            "    if (node.isMinLevel && self[node] > self[parent])\n"
            "        || (!node.isMinLevel && self[node] > self[parent]){",
            mid,
        )
    elif mid == "E3-M07":
        h = replace_once(
            h,
            "    if node.isMinLevel {\n"
            "      while let grandparent = node.grandParent(),\n"
            "            self[node] < self[grandparent] {",
            "    if !node.isMinLevel {\n"
            "      while let grandparent = node.grandParent(),\n"
            "            self[node] < self[grandparent] {",
            mid,
        )
    elif mid == "E3-M08":
        h = replace_once(
            h,
            "            self[node] < self[grandparent] {\n"
            "        swapAt(node, grandparent)\n"
            "        node = grandparent\n"
            "      }\n"
            "    } else {\n"
            "      while let grandparent = node.grandParent(),\n"
            "            self[node] > self[grandparent] {",
            "            self[node] > self[grandparent] {\n"
            "        swapAt(node, grandparent)\n"
            "        node = grandparent\n"
            "      }\n"
            "    } else {\n"
            "      while let grandparent = node.grandParent(),\n"
            "            self[node] > self[grandparent] {",
            mid,
        )
    elif mid == "E3-M09":
        h = replace_once(
            h,
            "      while let grandparent = node.grandParent(),\n"
            "            self[node] > self[grandparent] {\n"
            "        swapAt(node, grandparent)\n"
            "        node = grandparent\n"
            "      }\n"
            "    }\n"
            "  }\n"
            "}\n"
            "\n"
            "extension Heap._UnsafeHandle {\n"
            "  /// Sink the item at `node` to its correct position in the heap.\n"
            "  /// The given node must be minimum-ordered.",
            "      while let grandparent = node.grandParent(),\n"
            "            self[node] < self[grandparent] {\n"
            "        swapAt(node, grandparent)\n"
            "        node = grandparent\n"
            "      }\n"
            "    }\n"
            "  }\n"
            "}\n"
            "\n"
            "extension Heap._UnsafeHandle {\n"
            "  /// Sink the item at `node` to its correct position in the heap.\n"
            "  /// The given node must be minimum-ordered.",
            mid,
        )
    elif mid == "E3-M10":
        h = replace_once(
            h,
            "    if (node.isMinLevel && self[node] > self[parent])\n"
            "        || (!node.isMinLevel && self[node] < self[parent]){",
            "    if (node.isMinLevel && self[node] > self[parent]){",
            mid,
        )
    elif mid == "E3-M11":
        h = replace_once(
            h,
            "    while gc0.offset &+ 3 < count {\n"
            "      // Invariant: buffer slot at `node` is uninitialized\n"
            "\n"
            "      // We have four grandchildren, so we don't need to compare children.\n"
            "      let gc1 = _HeapNode(offset: gc0.offset &+ 1, level: gc0.level)\n"
            "      let minA = minValue(gc0, gc1)",
            "    while gc0.offset &+ 3 <= count {\n"
            "      // Invariant: buffer slot at `node` is uninitialized\n"
            "\n"
            "      // We have four grandchildren, so we don't need to compare children.\n"
            "      let gc1 = _HeapNode(offset: gc0.offset &+ 1, level: gc0.level)\n"
            "      let minA = minValue(gc0, gc1)",
            mid,
        )
    elif mid == "E3-M12":
        h = replace_once(
            h,
            "      let min = minValue(minA, minB)\n"
            "      guard self[min] < value else {\n"
            "        return // We're done -- `node` is a good place for `value`.\n"
            "      }",
            "      let min = minValue(minA, minB)\n"
            "      guard self[min] > value else {\n"
            "        return // We're done -- `node` is a good place for `value`.\n"
            "      }",
            mid,
        )
    elif mid == "E3-M13":
        h = replace_once(
            h,
            "      let parent = min.parent()\n"
            "      if self[parent] < value {\n"
            "        swapAt(parent, with: &value)\n"
            "      }\n"
            "    }\n"
            "\n"
            "    // At this point, we don't have a full complement of grandchildren, but\n"
            "    // we haven't finished sinking the item.\n"
            "\n"
            "    let c0 = node.leftChild()\n"
            "    if c0.offset >= count {\n"
            "      return // No more descendants to consider.\n"
            "    }\n"
            "    let min = _minDescendant(c0: c0, gc0: gc0)",
            "      let parent = min.parent()\n"
            "      if self[parent] > value {\n"
            "        swapAt(parent, with: &value)\n"
            "      }\n"
            "    }\n"
            "\n"
            "    // At this point, we don't have a full complement of grandchildren, but\n"
            "    // we haven't finished sinking the item.\n"
            "\n"
            "    let c0 = node.leftChild()\n"
            "    if c0.offset >= count {\n"
            "      return // No more descendants to consider.\n"
            "    }\n"
            "    let min = _minDescendant(c0: c0, gc0: gc0)",
            mid,
        )
    elif mid == "E3-M14":
        h = replace_once(
            h,
            "    let c0 = node.leftChild()\n"
            "    if c0.offset >= count {\n"
            "      return // No more descendants to consider.\n"
            "    }\n"
            "    let min = _minDescendant(c0: c0, gc0: gc0)",
            "    let c0 = node.leftChild()\n"
            "    if c0.offset > count {\n"
            "      return // No more descendants to consider.\n"
            "    }\n"
            "    let min = _minDescendant(c0: c0, gc0: gc0)",
            mid,
        )
    elif mid == "E3-M15":
        h = replace_once(
            h,
            "    let min = _minDescendant(c0: c0, gc0: gc0)\n"
            "    guard self[min] < value else {\n"
            "      return // We're done.\n"
            "    }",
            "    let min = _minDescendant(c0: c0, gc0: gc0)\n"
            "    guard self[min] <= value else {\n"
            "      return // We're done.\n"
            "    }",
            mid,
        )
    elif mid == "E3-M16":
        h = replace_once(
            h,
            "    if min < gc0 { return }\n"
            "\n"
            "    // If `min` was a grandchild, check the parent.\n"
            "    let parent = min.parent()\n"
            "    if self[parent] < value {\n"
            "      initialize(node, to: extract(parent))\n"
            "      node = parent\n"
            "    }\n"
            "  }\n"
            "\n"
            "  /// Returns the node holding the minimal item amongst the children &",
            "    if min > gc0 { return }\n"
            "\n"
            "    // If `min` was a grandchild, check the parent.\n"
            "    let parent = min.parent()\n"
            "    if self[parent] < value {\n"
            "      initialize(node, to: extract(parent))\n"
            "      node = parent\n"
            "    }\n"
            "  }\n"
            "\n"
            "  /// Returns the node holding the minimal item amongst the children &",
            mid,
        )
    elif mid == "E3-M17":
        h = replace_once(
            h,
            "    if gc0.offset < count {\n"
            "      if gc0.offset &+ 2 < count {\n"
            "        // We have three grandchildren. We don't need to compare direct children.\n"
            "        let gc1 = _HeapNode(offset: gc0.offset &+ 1, level: gc0.level)\n"
            "        let gc2 = _HeapNode(offset: gc0.offset &+ 2, level: gc0.level)\n"
            "        return minValue(minValue(gc0, gc1), gc2)\n"
            "      }",
            "    if gc0.offset < count {\n"
            "      if gc0.offset &+ 2 <= count {\n"
            "        // We have three grandchildren. We don't need to compare direct children.\n"
            "        let gc1 = _HeapNode(offset: gc0.offset &+ 1, level: gc0.level)\n"
            "        let gc2 = _HeapNode(offset: gc0.offset &+ 2, level: gc0.level)\n"
            "        return minValue(minValue(gc0, gc1), gc2)\n"
            "      }",
            mid,
        )
    elif mid == "E3-M18":
        h = replace_once(
            h,
            "    if c1.offset < count {\n"
            "      return minValue(c0, c1)\n"
            "    }\n"
            "\n"
            "    return c0\n"
            "  }\n"
            "\n"
            "  /// Sink the item at `node` to its correct position in the heap.\n"
            "  /// The given node must be maximum-ordered.",
            "    if c1.offset < count {\n"
            "      return maxValue(c0, c1)\n"
            "    }\n"
            "\n"
            "    return c0\n"
            "  }\n"
            "\n"
            "  /// Sink the item at `node` to its correct position in the heap.\n"
            "  /// The given node must be maximum-ordered.",
            mid,
        )
    elif mid == "E3-M19":
        h = replace_once(
            h,
            "      let max = maxValue(maxA, maxB)\n"
            "      guard value < self[max] else {\n"
            "        return // We're done -- `node` is a good place for `value`.\n"
            "      }",
            "      let max = maxValue(maxA, maxB)\n"
            "      guard value > self[max] else {\n"
            "        return // We're done -- `node` is a good place for `value`.\n"
            "      }",
            mid,
        )
    elif mid == "E3-M20":
        h = replace_once(
            h,
            "      let parent = max.parent()\n"
            "      if value < self[parent] {\n"
            "        swapAt(parent, with: &value)\n"
            "      }\n"
            "    }\n"
            "\n"
            "    // At this point, we don't have a full complement of grandchildren, but\n"
            "    // we haven't finished sinking the item.\n"
            "\n"
            "    let c0 = node.leftChild()\n"
            "    if c0.offset >= count {\n"
            "      return // No more descendants to consider.\n"
            "    }\n"
            "    let max = _maxDescendant(c0: c0, gc0: gc0)",
            "      let parent = max.parent()\n"
            "      if value > self[parent] {\n"
            "        swapAt(parent, with: &value)\n"
            "      }\n"
            "    }\n"
            "\n"
            "    // At this point, we don't have a full complement of grandchildren, but\n"
            "    // we haven't finished sinking the item.\n"
            "\n"
            "    let c0 = node.leftChild()\n"
            "    if c0.offset >= count {\n"
            "      return // No more descendants to consider.\n"
            "    }\n"
            "    let max = _maxDescendant(c0: c0, gc0: gc0)",
            mid,
        )
    elif mid == "E3-M21":
        h = replace_once(
            h,
            "    if max < gc0 { return }\n"
            "\n"
            "    // If `max` was a grandchild, check the parent.\n"
            "    let parent = max.parent()\n"
            "    if value < self[parent] {\n"
            "      initialize(node, to: extract(parent))\n"
            "      node = parent\n"
            "    }\n"
            "  }\n"
            "\n"
            "  /// Returns the node holding the maximal item amongst the children &",
            "    if max > gc0 { return }\n"
            "\n"
            "    // If `max` was a grandchild, check the parent.\n"
            "    let parent = max.parent()\n"
            "    if value < self[parent] {\n"
            "      initialize(node, to: extract(parent))\n"
            "      node = parent\n"
            "    }\n"
            "  }\n"
            "\n"
            "  /// Returns the node holding the maximal item amongst the children &",
            mid,
        )
    elif mid == "E3-M22":
        h = replace_once(
            h,
            "    if c1.offset < count {\n"
            "      return maxValue(c0, c1)\n"
            "    }\n"
            "\n"
            "    return c0\n"
            "  }\n"
            "}\n"
            "\n"
            "extension Heap._UnsafeHandle {\n"
            "  @inlinable\n"
            "  internal func heapify() {",
            "    if c1.offset < count {\n"
            "      return minValue(c0, c1)\n"
            "    }\n"
            "\n"
            "    return c0\n"
            "  }\n"
            "}\n"
            "\n"
            "extension Heap._UnsafeHandle {\n"
            "  @inlinable\n"
            "  internal func heapify() {",
            mid,
        )
    elif mid == "E3-M23":
        h = replace_once(
            h,
            "    while gc0.offset &+ 3 < count {\n"
            "      // Invariant: buffer slot at `node` is uninitialized\n"
            "\n"
            "      // We have four grandchildren, so we don't need to compare children.\n"
            "      let gc1 = _HeapNode(offset: gc0.offset &+ 1, level: gc0.level)\n"
            "      let maxA = maxValue(gc0, gc1)",
            "    while gc0.offset &+ 2 < count {\n"
            "      // Invariant: buffer slot at `node` is uninitialized\n"
            "\n"
            "      // We have four grandchildren, so we don't need to compare children.\n"
            "      let gc1 = _HeapNode(offset: gc0.offset &+ 1, level: gc0.level)\n"
            "      let maxA = maxValue(gc0, gc1)",
            mid,
        )
    elif mid == "E3-M24":
        h = replace_once(
            h,
            "    let limit = count / 2 // The first offset without a left child",
            "    let limit = count // The first offset without a left child",
            mid,
        )
    elif mid == "E3-M25":
        h = replace_once(
            h,
            "    if _HeapNode.isMinLevel(level) {\n"
            "      nodes._forEach { node in\n"
            "        trickleDownMin(node)\n"
            "      }\n"
            "    } else {\n"
            "      nodes._forEach { node in\n"
            "        trickleDownMax(node)\n"
            "      }\n"
            "    }",
            "    if !_HeapNode.isMinLevel(level) {\n"
            "      nodes._forEach { node in\n"
            "        trickleDownMin(node)\n"
            "      }\n"
            "    } else {\n"
            "      nodes._forEach { node in\n"
            "        trickleDownMax(node)\n"
            "      }\n"
            "    }",
            mid,
        )
    elif mid == "E3-M26":
        h = replace_once(
            h,
            "      _heapify(level, nodes)\n"
            "      level &-= 1",
            "      _heapify(level, nodes)\n"
            "      level &+= 1",
            mid,
        )
    elif mid == "E3-M27":
        h = replace_once(
            h,
            "    while level >= 0 {\n"
            "      let nodes = _HeapNode.allNodes(onLevel: level, limit: limit)\n"
            "      _heapify(level, nodes)\n"
            "      level &-= 1\n"
            "    }",
            "    while level > 0 {\n"
            "      let nodes = _HeapNode.allNodes(onLevel: level, limit: limit)\n"
            "      _heapify(level, nodes)\n"
            "      level &-= 1\n"
            "    }",
            mid,
        )
    elif mid == "E3-M28":
        n = replace_once(
            n,
            "    level & 0b1 == 0",
            "    level & 0b1 == 1",
            mid,
        )
        target = NODE
    else:
        raise SystemExit(f"unknown mutant {mid}")

    HANDLE.write_text(h)
    NODE.write_text(n)
    out = MUT_DIR / f"{mid}.swift"
    if mid == "E3-M28":
        shutil.copy2(NODE, out)
    else:
        shutil.copy2(HANDLE, out)
    return out


def classify(log: str, returncode: int, timed_out: bool) -> tuple[str, list[str]]:
    if timed_out:
        return "KILLED", ["TIMEOUT"]

    failing = sorted(
        set(
            re.findall(
                r"Test Case '-\[HeapTests\.(?:HeapTests|HeapNodeTests|AIGeneratedHeapTests) ([^\]]+)\]' failed",
                log,
            )
        )
    )
    # Also catch XCTest style without full class sometimes
    if not failing:
        failing = sorted(
            set(re.findall(r"error: -\[HeapTests\.[^\s]+ ([^\]]+)\] :", log))
        )

    crashed = bool(
        re.search(
            r"(Fatal error|Segmentation fault|signal (5|9|10|11)|EXC_|Illegal instruction|precondition failure|Swift runtime failure|fatalError)",
            log,
            re.I,
        )
    )
    # swift test nonzero with build failure
    build_fail = "error:" in log and "Compiling" in log and "Test Suite" not in log

    if returncode == 0 and not failing and not crashed:
        # Confirm executed tests
        if re.search(r"Executed \d+ tests, with 0 failures", log):
            return "SURVIVED", []
        # weird pass?
        return "SURVIVED", []

    if failing:
        return "KILLED", failing
    if crashed or returncode != 0:
        # runtime abort without named failing test
        return "KILLED", failing or ["CRASH_OR_NONZERO"]
    return "INVALID", failing


def run_suite(mid: str, suite: str, filt: str, timeout: int) -> dict:
    log_path = LOG_DIR / f"{mid}-{suite}.log"
    cmd = ["swift", "test", "--filter", filt]
    t0 = time.time()
    timed_out = False
    try:
        proc = subprocess.run(
            cmd,
            cwd=ROOT,
            capture_output=True,
            text=True,
            timeout=timeout,
        )
        out = (proc.stdout or "") + (proc.stderr or "")
        rc = proc.returncode
    except subprocess.TimeoutExpired as e:
        timed_out = True
        out = (e.stdout or "") + (e.stderr or "")
        if isinstance(out, bytes):
            out = out.decode("utf-8", errors="replace")
        out += f"\n\n[TIMEOUT after {timeout}s]\n"
        rc = 124
    elapsed = time.time() - t0
    log_path.write_text(out)
    status, failing = classify(out, rc, timed_out)
    # Extract executed counts if present
    m = re.search(r"Executed (\d+) tests, with (\d+) failures", out)
    executed = int(m.group(1)) if m else None
    failures = int(m.group(2)) if m else None
    return {
        "id": mid,
        "suite": suite,
        "status": status,
        "failing_tests": failing,
        "returncode": rc,
        "timed_out": timed_out,
        "elapsed_s": round(elapsed, 3),
        "executed": executed,
        "failures": failures,
        "log": str(log_path.relative_to(ROOT)),
    }


def main() -> None:
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    MUT_DIR.mkdir(parents=True, exist_ok=True)
    if not HANDLE_ORIG.exists() or not NODE_ORIG.exists():
        raise SystemExit("missing ORIG backups")

    ids = [f"E3-M{i:02d}" for i in range(1, 29)]
    only = sys.argv[1:]
    if only:
        ids = only

    # truncate jsonl if full run
    if not only:
        JSONL.write_text("")

    for mid in ids:
        print(f"=== {mid} ===", flush=True)
        apply_mutant(mid)
        timeout = HANG_TIMEOUT if mid == "E3-M26" else DEFAULT_TIMEOUT
        human = run_suite(mid, "human", HUMAN_FILTER, timeout)
        print(f"  human: {human['status']} fail={human['failing_tests'][:5]}", flush=True)
        ai = run_suite(mid, "ai", AI_FILTER, timeout)
        print(f"  ai:    {ai['status']} fail={ai['failing_tests'][:5]}", flush=True)
        restore()
        with JSONL.open("a") as f:
            f.write(json.dumps(human) + "\n")
            f.write(json.dumps(ai) + "\n")

    print("DONE", flush=True)


if __name__ == "__main__":
    main()
