#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PROD="Sources/ComplexModule/Complex+AlgebraicField.swift"
ORIG="research/Complex+AlgebraicField.swift.ORIG"
EXPECT_SHA="9f984d0229c4851537e5367bb944a7bd8073d35ea0e94084a201724baaca6f5b"
HUMAN_FILTER='ComplexTests.ArithmeticTests/testBaudinSmith|ComplexTests.ArithmeticTests/testDivisionByZero'
AI_FILTER='AIGeneratedComplexAlgebraicFieldTests'
LOGDIR="research/mutation-logs-e15"
JSONL="research/experiment-15-mutation-results.jsonl"
mkdir -p "$LOGDIR"
: > "$JSONL"

verify_prod() {
  local sha
  sha=$(shasum -a 256 "$PROD" | awk '{print $1}')
  if [[ "$sha" != "$EXPECT_SHA" ]]; then
    echo "INTEGRITY FAIL prod sha=$sha expected=$EXPECT_SHA" >&2
    exit 1
  fi
}

classify() {
  local log="$1"
  local label="$2"
  # Contamination: only executed AI test cases under human filter (not compile paths)
  if [[ "$label" == "human" ]] && rg -q "Test Case '-\\[[^]]*AIGenerated" "$log"; then
    echo "CONTAMINATED"
    return
  fi
  if rg -qi "signal code|Fatal error|precondition failure|fatalError|EXC_|Illegal instruction|Segmentation fault|caught signal" "$log"; then
    echo "KILLED-CRASH"
    return
  fi
  if rg -q " timed out|TIMEOUT" "$log"; then
    echo "KILLED-TIMEOUT"
    return
  fi
  if rg -q "error:" "$log" && ! rg -q "Test Case " "$log"; then
    echo "INVALID"
    return
  fi
  if rg -q "with 0 failures" "$log"; then
    echo "SURVIVED"
    return
  fi
  if rg -q "failed \\(|failures \\(| : failed|XCTAssert" "$log"; then
    echo "KILLED"
    return
  fi
  echo "INVALID"
}

force_rebuild_clients() {
  # @_transparent / @inlinable APIs are emitted into clients; force ComplexTests recompile
  touch Tests/ComplexTests/*.swift
  touch "$PROD"
}

run_suite() {
  local filter="$1" log="$2" label="$3"
  force_rebuild_clients
  set +e
  perl -e 'alarm shift; exec @ARGV' 90 swift test --filter "$filter" >"$log" 2>&1
  local ec=$?
  set -e
  if [[ $ec -eq 142 ]] || [[ $ec -eq 143 ]]; then
    echo "TIMEOUT" >>"$log"
  fi
  classify "$log" "$label"
}

cp "$ORIG" "$PROD"
verify_prod
force_rebuild_clients
swift test --filter "$AI_FILTER" >/dev/null 2>&1 || true

for i in $(seq 1 24); do
  id=$(printf 'E15-M%02d' "$i")
  echo "=== $id ==="
  cp "research/mutants-e15/${id}.swift" "$PROD"
  h=$(run_suite "$HUMAN_FILTER" "$LOGDIR/${id}-human.log" human)
  a=$(run_suite "$AI_FILTER" "$LOGDIR/${id}-ai.log" ai)
  echo "{\"id\":\"$id\",\"human\":\"$h\",\"ai\":\"$a\"}" | tee -a "$JSONL"
  cp "$ORIG" "$PROD"
  verify_prod
done

force_rebuild_clients
echo "DONE"
shasum -a 256 "$PROD"
