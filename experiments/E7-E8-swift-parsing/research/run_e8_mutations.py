#!/usr/bin/env python3
"""Experiment #8 mutation runner for Digits.swift (Runbook v2)."""

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
SRC = ROOT / "Sources/Parsing/ParserPrinters/Digits.swift"
ORIG = ROOT / "research/Digits.swift.ORIG"
LOG_DIR = ROOT / "research/mutation-logs-e8"
MUT_DIR = ROOT / "research/mutants-e8"
JSONL = ROOT / "research/experiment-8-mutation-results.jsonl"

PROD_SHA = "551333cb817917cdce03362e1949e848cd7245b9d8c1a91257407e3c531157ce"
AI_SHA = "f5525799b968cb0c7b43c35874b0c9843fa602dad66644be26c47858f39e888d"
AI_FILE = ROOT / "Tests/ParsingTests/AIGeneratedDigitsTests.swift"
HUMAN_FILTER = "ParsingTests.DigitsTests"
AI_FILTER = "AIGeneratedDigitsTests"
TIMEOUT = 30
REPO_SHA = "7160b25d39e4a38258a7fe71591fbe182b026d69"
MUTANT_IDS = [f"E8-M{i:02d}" for i in range(1, 25)]


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

    if mid == "E8-M01":
        t = replace_once(t, "while self.length.maximum.map({ length < $0 }) ?? true,", "while self.length.maximum.map({ length <= $0 }) ?? true,", mid)
    elif mid == "E8-M02":
        t = replace_once(t, "while self.length.maximum.map({ length < $0 }) ?? true,", "while self.length.maximum.map({ length > $0 }) ?? true,", mid)
    elif mid == "E8-M03":
        t = replace_once(t, "(output, overflow) = output.multipliedReportingOverflow(by: 10)", "(output, overflow) = output.multipliedReportingOverflow(by: 2)", mid)
    elif mid == "E8-M04":
        t = replace_once(t, "(output, overflow) = output.multipliedReportingOverflow(by: 10)", "(output, overflow) = output.multipliedReportingOverflow(by: 0)", mid)
    elif mid == "E8-M05":
        t = replace_once(t, "(output, overflow) = output.addingReportingOverflow(n)", "(output, overflow) = output.addingReportingOverflow(0)", mid)
    elif mid == "E8-M06":
        t = replace_once(
            t,
            "      guard !overflow else { throw overflowError() }\n"
            "      (output, overflow) = output.addingReportingOverflow(n)\n",
            "      guard overflow else { throw overflowError() }\n"
            "      (output, overflow) = output.addingReportingOverflow(n)\n",
            mid,
        )
    elif mid == "E8-M07":
        t = replace_once(
            t,
            "      (output, overflow) = output.addingReportingOverflow(n)\n"
            "      guard !overflow else { throw overflowError() }\n"
            "      length += 1\n",
            "      (output, overflow) = output.addingReportingOverflow(n)\n"
            "      guard overflow else { throw overflowError() }\n"
            "      length += 1\n",
            mid,
        )
    elif mid == "E8-M08":
        t = replace_once(t, "      length += 1\n", "      length += 2\n", mid)
    elif mid == "E8-M09":
        t = replace_once(t, "    guard length >= self.length.minimum\n", "    guard length > self.length.minimum\n", mid)
    elif mid == "E8-M10":
        t = replace_once(t, "    guard length >= self.length.minimum\n", "    guard length < self.length.minimum\n", mid)
    elif mid == "E8-M11":
        t = replace_once(
            t,
            "    guard length >= self.length.minimum\n"
            "    else { throw digitsError() }\n"
            "\n"
            "    input = try self.inputToBytes.unapply(bytes)\n",
            "    input = try self.inputToBytes.unapply(bytes)\n",
            mid,
        )
    elif mid == "E8-M12":
        t = replace_once(
            t,
            "      bytes.removeFirst()\n"
            "      (output, overflow) = output.multipliedReportingOverflow(by: 10)\n",
            "      (output, overflow) = output.multipliedReportingOverflow(by: 10)\n",
            mid,
        )
    elif mid == "E8-M13":
        t = replace_once(
            t,
            "      case .init(ascii: \"0\") ... .init(ascii: \"9\"):\n"
            "        return Int(n - .init(ascii: \"0\"))\n",
            "      case .init(ascii: \"1\") ... .init(ascii: \"9\"):\n"
            "        return Int(n - .init(ascii: \"0\"))\n",
            mid,
        )
    elif mid == "E8-M14":
        t = replace_once(
            t,
            "        return Int(n - .init(ascii: \"0\"))\n",
            "        return Int(n - .init(ascii: \"0\") + 1)\n",
            mid,
        )
    elif mid == "E8-M15":
        t = replace_once(
            t,
            "    input = try self.inputToBytes.unapply(bytes)\n"
            "    return output\n",
            "    input = try self.inputToBytes.unapply(bytes)\n"
            "    return length\n",
            mid,
        )
    elif mid == "E8-M16":
        t = replace_once(
            t,
            "    guard self.length.minimum != 0 || output != 0\n"
            "    else { return }\n",
            "    guard self.length.minimum != 0 || output == 0\n"
            "    else { return }\n",
            mid,
        )
    elif mid == "E8-M17":
        t = replace_once(t, "    guard output >= 0\n", "    guard output > 0\n", mid)
    elif mid == "E8-M18":
        t = replace_once(t, "    if let maximum = self.length.maximum, count > maximum {", "    if let maximum = self.length.maximum, count >= maximum {", mid)
    elif mid == "E8-M19":
        t = replace_once(t, "    if let maximum = self.length.maximum, count > maximum {", "    if let maximum = self.length.maximum, count < maximum {", mid)
    elif mid == "E8-M20":
        t = replace_once(
            t,
            "    for _ in 0..<max(0, self.length.minimum - count) {\n",
            "    for _ in 0..<max(0, self.length.minimum + count) {\n",
            mid,
        )
    elif mid == "E8-M21":
        t = replace_once(
            t,
            "      bytes.prepend(.init(ascii: \"0\"))\n",
            "      bytes.prepend(.init(ascii: \"1\"))\n",
            mid,
        )
    elif mid == "E8-M22":
        t = replace_once(
            t,
            "    input.prepend(contentsOf: try self.inputToBytes.unapply(bytes))\n",
            "    // mutated: omit prepend\n",
            mid,
        )
    elif mid == "E8-M23":
        t = replace_once(
            t,
            "    input = try self.inputToBytes.unapply(bytes)\n"
            "    return output\n",
            "    return output\n",
            mid,
        )
    elif mid == "E8-M24":
        t = replace_once(
            t,
            "    guard output >= 0\n"
            "    else {\n"
            "      throw PrintingError.failed(\n"
            "        summary: \"\"\"\n"
            "          round-trip expectation failed\n"
            "\n"
            "          A \"Digits\" parser tried to print \\(output). \"Digits\" parsers cannot parse or print \\\n"
            "          negative numbers.\n"
            "          \"\"\",\n"
            "        input: input\n"
            "      )\n"
            "    }\n"
            "\n"
            "    var bytes = InputToBytes.Output(String(output).utf8)\n",
            "    var bytes = InputToBytes.Output(String(output).utf8)\n",
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
        if any(m in text for m in ("fatal error", "precondition failure", "exited with unexpected signal", "illegal instruction")):
            if "xctassertequal failed" not in text and "error: -[" not in text:
                return "KILLED-CRASH"
        if "error: emit-module" in text or ("error:" in text and "compiling" in text and "executed" not in text):
            return "INVALID"
        return "KILLED"
    return "SURVIVED"


def extract_names(output: str) -> list[str]:
    return re.findall(r"Test Case '(-\[ParsingTests\.[^\]]+\])'", output)


def run_suite(filter_expr: str, log_path: Path, expect_ai: bool):
    proc = subprocess.Popen(
        ["swift", "test", "--filter", filter_expr],
        cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, start_new_session=True,
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
        if any("AIGenerated" not in n and "DigitsTests" in n for n in names):
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
            "id": mid, "human": human, "ai": ai,
            "human_seconds": round(ht, 3), "ai_seconds": round(at, 3),
            "human_rc": hrc, "ai_rc": arc,
            "human_contaminated": hc, "ai_contaminated": ac,
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
