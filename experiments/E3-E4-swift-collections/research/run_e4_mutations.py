#!/usr/bin/env python3
"""Experiment #4 mutation runner for OrderedSet+Insertions.swift."""

from __future__ import annotations

import json
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift"
ORIG = ROOT / "research/OrderedSet+Insertions.swift.ORIG"
LOG_DIR = ROOT / "research/mutation-logs-e4"
MUT_DIR = ROOT / "research/mutants-e4"
JSONL = ROOT / "research/experiment-4-mutation-results.jsonl"

PROD_SHA = "0eb00dc657e182f3254b10130bcaf6f9483b4b02d6126c47c01f0993caae5efd"
HUMAN_FILTER = (
    "OrderedSetTests.test_append$|OrderedSetTests.test_append_many|"
    "OrderedSetTests.test_append_contentsOf|OrderedSetTests.test_insert_at|"
    "OrderedSetTests.test_update_at|OrderedSetTests.test_updateOrAppend|"
    "OrderedSetTests.test_updateOrInsert|OrderedSetTests.test_replace"
)
AI_FILTER = "AIGeneratedOrderedSetInsertionsTests"
TIMEOUT = 30


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

    if mid == "E4-M01":
        t = replace_once(
            t,
            "    if let index = index { return (false, index) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, _elements.index(before: _elements.endIndex))",
            "    if let index = index { return (true, index) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, _elements.index(before: _elements.endIndex))",
            mid,
        )
    elif mid == "E4-M02":
        t = replace_once(
            t,
            "    let (index, bucket) = _find(item)\n"
            "    if let index = index { return (false, index) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, _elements.index(before: _elements.endIndex))",
            "    let (index, bucket) = _find(item)\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, _elements.index(before: _elements.endIndex))",
            mid,
        )
    elif mid == "E4-M03":
        t = replace_once(
            t,
            "    if let index = index { return (false, index) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, _elements.index(before: _elements.endIndex))",
            "    if let index = index { return (false, index) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (false, _elements.index(before: _elements.endIndex))",
            mid,
        )
    elif mid == "E4-M04":
        t = replace_once(
            t,
            "    if let index = index { return (false, index) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, _elements.index(before: _elements.endIndex))",
            "    if let index = index { return (false, index) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, 0)",
            mid,
        )
    elif mid == "E4-M05":
        t = replace_once(
            t,
            "  internal mutating func _appendNew(_ item: Element, in bucket: _Bucket) {\n"
            "    _elements.append(item)\n"
            "\n"
            "    guard _elements.count <= _capacity else {\n"
            "      _regenerateHashTable()\n"
            "      return\n"
            "    }",
            "  internal mutating func _appendNew(_ item: Element, in bucket: _Bucket) {\n"
            "    _elements.append(item)\n"
            "\n"
            "    guard _elements.count < _capacity else {\n"
            "      _regenerateHashTable()\n"
            "      return\n"
            "    }",
            mid,
        )
    elif mid == "E4-M06":
        t = replace_once(
            t,
            "      assert(!hashTable.isOccupied(bucket))\n"
            "      hashTable[bucket] = _elements.count - 1\n"
            "    }\n"
            "  }\n"
            "\n"
            "  @inlinable\n"
            "  @discardableResult\n"
            "  internal mutating func _append(",
            "      assert(!hashTable.isOccupied(bucket))\n"
            "      hashTable[bucket] = _elements.count\n"
            "    }\n"
            "  }\n"
            "\n"
            "  @inlinable\n"
            "  @discardableResult\n"
            "  internal mutating func _append(",
            mid,
        )
    elif mid == "E4-M07":
        t = replace_once(
            t,
            "    let (existing, bucket) = _find(item)\n"
            "    if let existing = existing { return (false, existing) }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (true, index)",
            "    let (existing, bucket) = _find(item)\n"
            "    if let existing = existing { return (true, existing) }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (true, index)",
            mid,
        )
    elif mid == "E4-M08":
        t = replace_once(
            t,
            "    let (existing, bucket) = _find(item)\n"
            "    if let existing = existing { return (false, existing) }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (true, index)",
            "    let (existing, bucket) = _find(item)\n"
            "    if let existing = existing { return (false, index) }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (true, index)",
            mid,
        )
    elif mid == "E4-M09":
        t = replace_once(
            t,
            "    let (existing, bucket) = _find(item)\n"
            "    if let existing = existing { return (false, existing) }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (true, index)",
            "    let (existing, bucket) = _find(item)\n"
            "    if let existing = existing { return (false, existing) }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (true, index + 1)",
            mid,
        )
    elif mid == "E4-M10":
        t = replace_once(
            t,
            "    let (existing, bucket) = _find(item)\n"
            "    if let existing = existing { return (false, existing) }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (true, index)",
            "    let (existing, bucket) = _find(item)\n"
            "    if let existing = existing { return (false, existing) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, index)",
            mid,
        )
    elif mid == "E4-M11":
        t = replace_once(
            t,
            "  ) {\n"
            "    guard _elements.count < _capacity else {\n"
            "      _elements.insert(item, at: index)\n"
            "      _regenerateHashTable()\n"
            "      return\n"
            "    }",
            "  ) {\n"
            "    guard _elements.count <= _capacity else {\n"
            "      _elements.insert(item, at: index)\n"
            "      _regenerateHashTable()\n"
            "      return\n"
            "    }",
            mid,
        )
    elif mid == "E4-M12":
        t = replace_once(
            t,
            "      hashTable.adjustContents(preparingForInsertionOfElementAtOffset: index, in: _elements)\n"
            "      hashTable[bucket] = index",
            "      hashTable.adjustContents(preparingForInsertionOfElementAtOffset: index, in: _elements)\n"
            "      hashTable[bucket] = index + 1",
            mid,
        )
    elif mid == "E4-M13":
        t = replace_once(
            t,
            "    precondition(\n"
            "      item == old,\n"
            "      \"The replacement item must compare equal to the original\")\n"
            "    _elements[index] = item\n"
            "    return old",
            "    precondition(\n"
            "      item == old,\n"
            "      \"The replacement item must compare equal to the original\")\n"
            "    return old",
            mid,
        )
    elif mid == "E4-M14":
        t = replace_once(
            t,
            "    precondition(\n"
            "      item == old,\n"
            "      \"The replacement item must compare equal to the original\")\n"
            "    _elements[index] = item\n"
            "    return old",
            "    precondition(\n"
            "      item == old,\n"
            "      \"The replacement item must compare equal to the original\")\n"
            "    _elements[index] = item\n"
            "    return item",
            mid,
        )
    elif mid == "E4-M15":
        t = replace_once(
            t,
            "    _appendNew(item, in: bucket)\n"
            "    swapAt(index, count - 1)\n"
            "    return removeLast()",
            "    _appendNew(item, in: bucket)\n"
            "    swapAt(index, 0)\n"
            "    return removeLast()",
            mid,
        )
    elif mid == "E4-M16":
        t = replace_once(
            t,
            "    _appendNew(item, in: bucket)\n"
            "    swapAt(index, count - 1)\n"
            "    return removeLast()",
            "    _appendNew(item, in: bucket)\n"
            "    return removeLast()",
            mid,
        )
    elif mid == "E4-M17":
        t = replace_once(
            t,
            "    if existing == index {\n"
            "      return update(item, at: index)\n"
            "    }",
            "    if existing != index {\n"
            "      return update(item, at: index)\n"
            "    }",
            mid,
        )
    elif mid == "E4-M18":
        t = replace_once(
            t,
            "    if existing == index {\n"
            "      return update(item, at: index)\n"
            "    }\n"
            "\n"
            "    precondition(existing == nil, \"Duplicate element\")\n"
            "    return _replaceNew(at: index, with: item, in: bucket)",
            "    precondition(existing == nil, \"Duplicate element\")\n"
            "    return _replaceNew(at: index, with: item, in: bucket)",
            mid,
        )
    elif mid == "E4-M19":
        t = replace_once(
            t,
            "    let (inserted, index) = _append(item)\n"
            "    if inserted { return nil }\n"
            "    let old = _elements[index]\n"
            "    _elements[index] = item\n"
            "    _checkInvariants()\n"
            "    return old",
            "    let (inserted, index) = _append(item)\n"
            "    if !inserted { return nil }\n"
            "    let old = _elements[index]\n"
            "    _elements[index] = item\n"
            "    _checkInvariants()\n"
            "    return old",
            mid,
        )
    elif mid == "E4-M20":
        t = replace_once(
            t,
            "    let (inserted, index) = _append(item)\n"
            "    if inserted { return nil }\n"
            "    let old = _elements[index]\n"
            "    _elements[index] = item\n"
            "    _checkInvariants()\n"
            "    return old",
            "    let (inserted, index) = _append(item)\n"
            "    if inserted { return nil }\n"
            "    return nil",
            mid,
        )
    elif mid == "E4-M21":
        t = replace_once(
            t,
            "    if let existing = existing {\n"
            "      let old = _elements[existing]\n"
            "      _elements[existing] = item\n"
            "      return (old, existing)\n"
            "    }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (nil, index)",
            "    if let existing = existing {\n"
            "      let old = _elements[existing]\n"
            "      _elements[existing] = item\n"
            "      return (old, index)\n"
            "    }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (nil, index)",
            mid,
        )
    elif mid == "E4-M22":
        t = replace_once(
            t,
            "    if let existing = existing {\n"
            "      let old = _elements[existing]\n"
            "      _elements[existing] = item\n"
            "      return (old, existing)\n"
            "    }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (nil, index)",
            "    if let existing = existing {\n"
            "      _insertNew(item, at: index, in: bucket)\n"
            "      return (nil, index)\n"
            "    } else {\n"
            "      let old = _elements[index]\n"
            "      _elements[index] = item\n"
            "      return (old, index)\n"
            "    }",
            mid,
        )
    elif mid == "E4-M23":
        t = replace_once(
            t,
            "    if let existing = existing {\n"
            "      let old = _elements[existing]\n"
            "      _elements[existing] = item\n"
            "      return (old, existing)\n"
            "    }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (nil, index)",
            "    if let existing = existing {\n"
            "      let old = _elements[existing]\n"
            "      _elements[existing] = item\n"
            "      return (old, existing)\n"
            "    }\n"
            "    _insertNew(item, at: index, in: bucket)\n"
            "    return (nil, 0)",
            mid,
        )
    elif mid == "E4-M24":
        t = replace_once(
            t,
            "  internal mutating func _appendNew(_ item: Element, in bucket: _Bucket) {\n"
            "    _elements.append(item)\n"
            "\n"
            "    guard _elements.count <= _capacity else {\n"
            "      _regenerateHashTable()\n"
            "      return\n"
            "    }",
            "  internal mutating func _appendNew(_ item: Element, in bucket: _Bucket) {\n"
            "    _elements.append(item)\n"
            "\n"
            "    guard _elements.count <= _capacity else {\n"
            "      return\n"
            "    }",
            mid,
        )
    elif mid == "E4-M25":
        t = replace_once(
            t,
            "    guard _elements.count < _capacity else {\n"
            "      _elements.insert(item, at: index)\n"
            "      _regenerateHashTable()\n"
            "      return\n"
            "    }",
            "    guard _elements.count < _capacity else {\n"
            "      _elements.append(item)\n"
            "      _regenerateHashTable()\n"
            "      return\n"
            "    }",
            mid,
        )
    elif mid == "E4-M26":
        t = replace_once(
            t,
            "    if let index = index { return (false, index) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, _elements.index(before: _elements.endIndex))",
            "    if let index = index { return (false, index + 1) }\n"
            "    _appendNew(item, in: bucket)\n"
            "    return (true, _elements.index(before: _elements.endIndex))",
            mid,
        )
    else:
        raise SystemExit(f"unknown mutant {mid}")

    SRC.write_text(t)
    shutil.copy2(SRC, MUT_DIR / f"{mid}.swift")


def classify(log: str, returncode: int, timed_out: bool) -> tuple[str, list[str], str]:
    if timed_out:
        return "KILLED-TIMEOUT", ["TIMEOUT"], "timeout"

    failing = sorted(
        set(
            re.findall(
                r"Test Case '-\[OrderedCollectionsTests\.(?:OrderedSetTests|AIGeneratedOrderedSetInsertionsTests) ([^\]]+)\]' failed",
                log,
            )
        )
    )

    crash = bool(
        re.search(
            r"(Fatal error|precondition failure|Assertion failed|Segmentation fault|signal (5|9|10|11)|EXC_|Swift runtime failure|fatalError|_checkInvariants)",
            log,
            re.I,
        )
    )

    if returncode == 0 and not failing and not crash:
        if re.search(r"Executed \d+ tests, with 0 failures", log):
            return "SURVIVED", [], ""
        return "SURVIVED", [], ""

    if failing and not crash:
        return "KILLED", failing, ""
    if crash:
        note = "crash/precondition/invariant"
        m = re.search(
            r"(Fatal error[^\n]*|precondition failure[^\n]*|Assertion failed[^\n]*|[^\n]*Assertion failed)",
            log,
        )
        if m:
            note = m.group(1).strip()[:160]
        return "KILLED-CRASH", failing or ["CRASH"], note
    if failing:
        return "KILLED", failing, ""
    return "KILLED-CRASH", ["NONZERO"], f"returncode={returncode}"


def run_suite(mid: str, suite: str, filt: str) -> dict:
    log_path = LOG_DIR / f"{mid}-{suite}.log"
    t0 = time.time()
    timed_out = False
    try:
        proc = subprocess.run(
            ["swift", "test", "--filter", filt],
            cwd=ROOT,
            capture_output=True,
            text=True,
            timeout=TIMEOUT,
        )
        out = (proc.stdout or "") + (proc.stderr or "")
        rc = proc.returncode
    except subprocess.TimeoutExpired as e:
        timed_out = True
        out = ""
        if e.stdout:
            out += e.stdout if isinstance(e.stdout, str) else e.stdout.decode("utf-8", "replace")
        if e.stderr:
            out += e.stderr if isinstance(e.stderr, str) else e.stderr.decode("utf-8", "replace")
        out += f"\n\n[TIMEOUT after {TIMEOUT}s]\n"
        rc = 124
    elapsed = time.time() - t0
    log_path.write_text(out)
    status, failing, note = classify(out, rc, timed_out)
    m = re.search(r"Executed (\d+) tests, with (\d+) failures", out)
    return {
        "id": mid,
        "suite": suite,
        "status": status,
        "failing_tests": failing,
        "note": note,
        "returncode": rc,
        "timed_out": timed_out,
        "elapsed_s": round(elapsed, 3),
        "executed": int(m.group(1)) if m else None,
        "failures": int(m.group(2)) if m else None,
        "log": str(log_path.relative_to(ROOT)),
    }


def main() -> None:
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    MUT_DIR.mkdir(parents=True, exist_ok=True)
    assert ORIG.exists()
    assert shasum(ORIG) == PROD_SHA

    ids = [f"E4-M{i:02d}" for i in range(1, 27)]
    if len(sys.argv) > 1:
        ids = sys.argv[1:]

    if ids == [f"E4-M{i:02d}" for i in range(1, 27)]:
        JSONL.write_text("")

    # Dry-validate applies
    if "--validate-only" in sys.argv:
        for mid in [f"E4-M{i:02d}" for i in range(1, 27)]:
            apply_mutant(mid)
            print(mid, "OK")
            restore()
        print("validate done")
        return

    for mid in ids:
        print(f"=== {mid} ===", flush=True)
        apply_mutant(mid)
        human = run_suite(mid, "human", HUMAN_FILTER)
        print(f"  human: {human['status']} {human['failing_tests'][:4]} {human.get('note','')}", flush=True)
        ai = run_suite(mid, "ai", AI_FILTER)
        print(f"  ai:    {ai['status']} {ai['failing_tests'][:4]} {ai.get('note','')}", flush=True)
        restore()
        with JSONL.open("a") as f:
            f.write(json.dumps(human) + "\n")
            f.write(json.dumps(ai) + "\n")

    print("DONE", flush=True)


if __name__ == "__main__":
    main()
