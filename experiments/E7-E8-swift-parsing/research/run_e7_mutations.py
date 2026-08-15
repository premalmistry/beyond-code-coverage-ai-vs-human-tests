#!/usr/bin/env python3
"""Experiment #7 mutation runner for Prefix.swift (Runbook v2)."""

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
SRC = ROOT / "Sources/Parsing/ParserPrinters/Prefix.swift"
ORIG = ROOT / "research/Prefix.swift.ORIG"
LOG_DIR = ROOT / "research/mutation-logs-e7"
MUT_DIR = ROOT / "research/mutants-e7"
JSONL = ROOT / "research/experiment-7-mutation-results.jsonl"

PROD_SHA = "da91af08f8fcf2116542fd1d423d1e1322312a15ba135de83a4085358f4159e6"
AI_SHA = "a0fc2c7ab3db3346e39497e73f9804098a92ae8a41ef37188975364005255b03"
AI_FILE = ROOT / "Tests/ParsingTests/AIGeneratedPrefixTests.swift"
HUMAN_FILTER = "ParsingTests.PrefixTests"
AI_FILTER = "AIGeneratedPrefixTests"
TIMEOUT = 30
REPO_SHA = "7160b25d39e4a38258a7fe71591fbe182b026d69"

MUTANT_IDS = [f"E7-M{i:02d}" for i in range(1, 25)]


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

    if mid == "E7-M01":
        t = replace_once(
            t,
            "    var prefix = self.maximum.map(input.prefix) ?? input\n"
            "    prefix = self.predicate.map { prefix.prefix(while: $0) } ?? prefix\n",
            "    var prefix = input\n"
            "    prefix = self.predicate.map { prefix.prefix(while: $0) } ?? prefix\n",
            mid,
        )
    elif mid == "E7-M02":
        t = replace_once(
            t,
            "    prefix = self.predicate.map { prefix.prefix(while: $0) } ?? prefix\n",
            "    prefix = prefix\n",
            mid,
        )
    elif mid == "E7-M03":
        t = replace_once(
            t,
            "    let count = prefix.count\n"
            "    input.removeFirst(count)\n",
            "    let count = prefix.count\n"
            "    input.removeFirst(0)\n",
            mid,
        )
    elif mid == "E7-M04":
        t = replace_once(
            t,
            "    let count = prefix.count\n"
            "    input.removeFirst(count)\n",
            "    let count = prefix.count\n"
            "    input.removeFirst(Swift.max(0, count - 1))\n",
            mid,
        )
    elif mid == "E7-M05":
        t = replace_once(
            t,
            "    guard count >= self.minimum else {\n",
            "    guard count > self.minimum else {\n",
            mid,
        )
    elif mid == "E7-M06":
        t = replace_once(
            t,
            "    guard count >= self.minimum else {\n",
            "    guard count < self.minimum else {\n",
            mid,
        )
    elif mid == "E7-M07":
        t = replace_once(
            t,
            "    return prefix\n"
            "  }\n"
            "}\n"
            "\n"
            "extension Prefix: ParserPrinter where Input: PrependableCollection {\n",
            "    return input\n"
            "  }\n"
            "}\n"
            "\n"
            "extension Prefix: ParserPrinter where Input: PrependableCollection {\n",
            mid,
        )
    elif mid == "E7-M08":
        t = replace_once(
            t,
            "    let count = prefix.count\n"
            "    input.removeFirst(count)\n"
            "    guard count >= self.minimum else {\n"
            "      let atLeast = self.minimum - count\n"
            "      throw ParsingError.expectedInput(\n"
            "        \"\"\"\n"
            "        \\(self.minimum - count) \\(count == 0 ? \"\" : \"more \")element\\(atLeast == 1 ? \"\" : \"s\")\\\n"
            "        \\(self.predicate == nil ? \"\" : \" satisfying predicate\")\n"
            "        \"\"\",\n"
            "        at: input\n"
            "      )\n"
            "    }\n"
            "    return prefix\n",
            "    let count = prefix.count\n"
            "    guard count >= self.minimum else {\n"
            "      let atLeast = self.minimum - count\n"
            "      throw ParsingError.expectedInput(\n"
            "        \"\"\"\n"
            "        \\(self.minimum - count) \\(count == 0 ? \"\" : \"more \")element\\(atLeast == 1 ? \"\" : \"s\")\\\n"
            "        \\(self.predicate == nil ? \"\" : \" satisfying predicate\")\n"
            "        \"\"\",\n"
            "        at: input\n"
            "      )\n"
            "    }\n"
            "    input.removeFirst(count)\n"
            "    return prefix\n",
            mid,
        )
    elif mid == "E7-M09":
        t = replace_once(
            t,
            "    var prefix = self.maximum.map(input.prefix) ?? input\n",
            "    var prefix = input.prefix(self.minimum)\n",
            mid,
        )
    elif mid == "E7-M10":
        t = replace_once(
            t,
            "  public init(while predicate: @escaping (Input.Element) -> Bool) {\n"
            "    self.minimum = 0\n"
            "    self.maximum = nil\n"
            "    self.predicate = predicate\n"
            "  }\n",
            "  public init(while predicate: @escaping (Input.Element) -> Bool) {\n"
            "    self.minimum = 1\n"
            "    self.maximum = nil\n"
            "    self.predicate = predicate\n"
            "  }\n",
            mid,
        )
    elif mid == "E7-M11":
        t = replace_once(
            t,
            "    guard count >= self.minimum\n"
            "    else {\n"
            "      let description = describe(input).map { \"\\n\\n\\($0.debugDescription)\" } ?? \"\"\n"
            "      throw PrintingError.failed(\n"
            "        summary: \"\"\"\n"
            "          round-trip expectation failed\n"
            "\n"
            "          A \"Prefix\" parser that parses at least \\(self.minimum) \\\n",
            "    guard count > self.minimum\n"
            "    else {\n"
            "      let description = describe(input).map { \"\\n\\n\\($0.debugDescription)\" } ?? \"\"\n"
            "      throw PrintingError.failed(\n"
            "        summary: \"\"\"\n"
            "          round-trip expectation failed\n"
            "\n"
            "          A \"Prefix\" parser that parses at least \\(self.minimum) \\\n",
            mid,
        )
    elif mid == "E7-M12":
        t = replace_once(
            t,
            "    guard count >= self.minimum\n"
            "    else {\n"
            "      let description = describe(input).map { \"\\n\\n\\($0.debugDescription)\" } ?? \"\"\n"
            "      throw PrintingError.failed(\n"
            "        summary: \"\"\"\n"
            "          round-trip expectation failed\n"
            "\n"
            "          A \"Prefix\" parser that parses at least \\(self.minimum) \\\n",
            "    guard count < self.minimum\n"
            "    else {\n"
            "      let description = describe(input).map { \"\\n\\n\\($0.debugDescription)\" } ?? \"\"\n"
            "      throw PrintingError.failed(\n"
            "        summary: \"\"\"\n"
            "          round-trip expectation failed\n"
            "\n"
            "          A \"Prefix\" parser that parses at least \\(self.minimum) \\\n",
            mid,
        )
    elif mid == "E7-M13":
        t = replace_once(
            t,
            "      guard count <= maximum\n"
            "      else {\n",
            "      guard count < maximum\n"
            "      else {\n",
            mid,
        )
    elif mid == "E7-M14":
        t = replace_once(
            t,
            "      guard count <= maximum\n"
            "      else {\n",
            "      guard count > maximum\n"
            "      else {\n",
            mid,
        )
    elif mid == "E7-M15":
        t = replace_once(
            t,
            "      guard output.allSatisfy(predicate)\n"
            "      else {\n",
            "      guard !output.allSatisfy(predicate)\n"
            "      else {\n",
            mid,
        )
    elif mid == "E7-M16":
        t = replace_once(
            t,
            "      if count != maximum {\n"
            "        guard input.first.map(predicate) != true\n",
            "      if count == maximum {\n"
            "        guard input.first.map(predicate) != true\n",
            mid,
        )
    elif mid == "E7-M17":
        t = replace_once(
            t,
            "        guard input.first.map(predicate) != true\n"
            "        else {\n",
            "        guard input.first.map(predicate) == true\n"
            "        else {\n",
            mid,
        )
    elif mid == "E7-M18":
        t = replace_once(
            t,
            "    input.prepend(contentsOf: output)\n",
            "    // mutated: omit prepend\n",
            mid,
        )
    elif mid == "E7-M19":
        t = replace_once(
            t,
            "    if let maximum = self.maximum {\n"
            "      guard count <= maximum\n"
            "      else {\n"
            "        let description = describe(input).map { \"\\n\\n\\($0.debugDescription)\" } ?? \"\"\n"
            "        throw PrintingError.failed(\n"
            "          summary: \"\"\"\n"
            "            round-trip expectation failed\n"
            "\n"
            "            A \"Prefix\" parser that parses at most \\(maximum) element\\(maximum == 1 ? \"\" : \"s\") was \\\n"
            "            given \\(count) element\\(count == 1 ? \"\" : \"s\") to print.\\(description)\n"
            "            \"\"\",\n"
            "          input: input\n"
            "        )\n"
            "      }\n"
            "    }\n",
            "    // mutated: omit maximum validation\n",
            mid,
        )
    elif mid == "E7-M20":
        t = replace_once(
            t,
            "      guard output.allSatisfy(predicate)\n"
            "      else {\n"
            "        throw PrintingError.failed(\n"
            "          summary: \"\"\"\n"
            "            round-trip expectation failed\n"
            "\n"
            "            A \"Prefix\" parser's predicate failed to satisfy all elements it was handed to print.\n"
            "\n"
            "            During a round-trip, the \"Prefix\" parser would have stopped parsing at this element, \\\n"
            "            which means its data is in an invalid state.\n"
            "            \"\"\",\n"
            "          input: input\n"
            "        )\n"
            "      }\n",
            "      // mutated: omit allSatisfy guard\n",
            mid,
        )
    elif mid == "E7-M21":
        t = replace_once(
            t,
            "    prefix = self.predicate.map { prefix.prefix(while: $0) } ?? prefix\n",
            "    prefix = self.predicate.map { _ in prefix.prefix(while: { _ in true }) } ?? prefix\n",
            mid,
        )
    elif mid == "E7-M22":
        t = replace_once(
            t,
            "    let count = prefix.count\n"
            "    input.removeFirst(count)\n"
            "    guard count >= self.minimum else {\n"
            "      let atLeast = self.minimum - count\n"
            "      throw ParsingError.expectedInput(\n"
            "        \"\"\"\n"
            "        \\(self.minimum - count) \\(count == 0 ? \"\" : \"more \")element\\(atLeast == 1 ? \"\" : \"s\")\\\n"
            "        \\(self.predicate == nil ? \"\" : \" satisfying predicate\")\n"
            "        \"\"\",\n"
            "        at: input\n"
            "      )\n"
            "    }\n"
            "    return prefix\n",
            "    let count = prefix.count\n"
            "    input.removeFirst(count)\n"
            "    return prefix\n",
            mid,
        )
    elif mid == "E7-M23":
        t = replace_once(
            t,
            "  public init(while predicate: @escaping (Input.Element) -> Bool) {\n"
            "    self.minimum = 0\n"
            "    self.maximum = nil\n"
            "    self.predicate = predicate\n"
            "  }\n",
            "  public init(while predicate: @escaping (Input.Element) -> Bool) {\n"
            "    self.minimum = 0\n"
            "    self.maximum = 0\n"
            "    self.predicate = predicate\n"
            "  }\n",
            mid,
        )
    elif mid == "E7-M24":
        t = replace_once(
            t,
            "      if count != maximum {\n"
            "        guard input.first.map(predicate) != true\n"
            "        else {\n"
            "          throw PrintingError.failed(\n"
            "            summary: \"\"\"\n"
            "              round-trip expectation failed\n"
            "\n"
            "              A \"Prefix\" parser's predicate satisfied the first element printed by the next printer.\n"
            "\n"
            "              During a round-trip, the \"Prefix\" parser would have parsed this element, which means \\\n"
            "              the data handed to the next printer is in an invalid state.\n"
            "              \"\"\",\n"
            "            input: input\n"
            "          )\n"
            "        }\n"
            "      }\n",
            "      // mutated: omit next-element check\n",
            mid,
        )
    else:
        raise SystemExit(f"unknown {mid}")

    SRC.write_text(t)
    shutil.copy2(SRC, MUT_DIR / f"{mid}.swift")


def classify(rc: int, output: str, timed_out: bool) -> str:
    if timed_out:
        return "KILLED-TIMEOUT"
    text = output.lower()
    if rc != 0:
        if any(
            m in text
            for m in (
                "fatal error",
                "precondition failure",
                "exited with unexpected signal",
                "illegal instruction",
            )
        ):
            if "xctassertequal failed" not in text and "error: -[" not in text:
                return "KILLED-CRASH"
        if "error: emit-module" in text or (
            "error:" in text and "compiling" in text and "executed" not in text
        ):
            return "INVALID"
        return "KILLED"
    return "SURVIVED"


def extract_names(output: str) -> list[str]:
    return re.findall(r"Test Case '(-\[ParsingTests\.[^\]]+\])'", output)


def run_suite(filter_expr: str, log_path: Path, expect_ai: bool):
    proc = subprocess.Popen(
        ["swift", "test", "--filter", filter_expr],
        cwd=ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        start_new_session=True,
    )
    t0 = time.time()
    timed_out = False
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
    names = extract_names(out)
    contaminated = False
    if expect_ai:
        if any("AIGenerated" not in n and "PrefixTests" in n for n in names):
            contaminated = True
    else:
        if any("AIGenerated" in n for n in names):
            contaminated = True
    if contaminated:
        return "CONTAMINATED", elapsed, rc, True
    return classify(rc, out, timed_out), elapsed, rc, False


def integrity_preflight() -> None:
    assert shasum(SRC) == PROD_SHA
    assert shasum(AI_FILE) == AI_SHA
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
    assert head == REPO_SHA, head


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
        human, ht, hrc, hc = run_suite(HUMAN_FILTER, LOG_DIR / f"{mid}-human.log", False)
        ai, at, arc, ac = run_suite(AI_FILTER, LOG_DIR / f"{mid}-ai.log", True)
        restore()
        row = {
            "id": mid,
            "human": human,
            "ai": ai,
            "human_seconds": round(ht, 3),
            "ai_seconds": round(at, 3),
            "human_rc": hrc,
            "ai_rc": arc,
            "human_contaminated": hc,
            "ai_contaminated": ac,
        }
        with JSONL.open("a") as f:
            f.write(json.dumps(row) + "\n")
        print(json.dumps(row), flush=True)
        if hc or ac:
            raise SystemExit(f"CONTAMINATED {mid}")
    restore()
    print("DONE", len(ids), flush=True)


if __name__ == "__main__":
    main()
