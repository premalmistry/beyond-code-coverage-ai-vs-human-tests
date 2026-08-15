#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PROD="Sources/BasicContainers/RigidArray/RigidArray+Append.swift"
ORIG="research/RigidArray+Append.swift.ORIG"
EXPECT_SHA="3075e1f0b035fae7b22025ae6c39ae4374e74894f1c05235e212ad815485c086"
HUMAN_FILTER='RigidArrayTests.test_append$|RigidArrayTests.test_pushLast|RigidArrayTests.test_append_addingCount_full|RigidArrayTests.test_append_addingCount_partial|RigidArrayTests.test_append_moving_UnsafeMutableBufferPointer|RigidArrayTests.test_append_moving_OutputSpan|RigidArrayTests.test_append_copying_MinimalSequence|RigidArrayTests.test_append_copying_Span'
AI_FILTER='AIGeneratedRigidArrayAppendTests'
LOGDIR="research/mutation-logs-e12"
JSONL="research/experiment-12-mutation-results.jsonl"
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
  if rg -q "AIGenerated" "$log" && [[ "$2" == "human" ]]; then
    echo "CONTAMINATED"
    return
  fi
  if rg -q "error: aborted|Fatal error|precondition failure|fatalError|EXC_|caught signal|Illegal instruction|Segmentation fault" "$log"; then
    echo "KILLED-CRASH"
    return
  fi
  if rg -q " timed out|TIMEOUT" "$log"; then
    echo "KILLED-TIMEOUT"
    return
  fi
  if rg -q "error:" "$log" && ! rg -q "Executed .* tests" "$log"; then
    # build failure
    echo "INVALID"
    return
  fi
  if rg -q "failed|failures|error:" "$log" && rg -q "Executed" "$log"; then
    if rg -q "with 0 failures" "$log"; then
      echo "SURVIVED"
    else
      echo "KILLED"
    fi
    return
  fi
  if rg -q "with 0 failures" "$log"; then
    echo "SURVIVED"
    return
  fi
  if rg -q "failed \\(|failures \\(" "$log"; then
    echo "KILLED"
    return
  fi
  echo "INVALID"
}

run_suite() {
  local filter="$1" log="$2" label="$3"
  set +e
  perl -e 'alarm shift; exec @ARGV' 60 swift test --filter "$filter" >"$log" 2>&1
  local ec=$?
  set -e
  if [[ $ec -eq 142 ]] || [[ $ec -eq 143 ]]; then
    echo "TIMEOUT" >>"$log"
  fi
  classify "$log" "$label"
}

cp "$ORIG" "$PROD"
verify_prod

for m in $(seq -w 1 24); do
  id="E12-M${m}"
  # normalize E12-M01 style
  id=$(printf 'E12-M%02d' "$((10#$m))")
  mutant="research/mutants-e12/${id}.swift"
  echo "=== $id ==="
  cp "$mutant" "$PROD"
  hlog="$LOGDIR/${id}-human.log"
  alog="$LOGDIR/${id}-ai.log"
  hout=$(run_suite "$HUMAN_FILTER" "$hlog" human)
  aout=$(run_suite "$AI_FILTER" "$alog" ai)
  # contamination check on human inventory
  if rg -q "AIGenerated" "$hlog"; then
    hout="CONTAMINATED"
  fi
  echo "${id} human=$hout ai=$aout"
  printf '{"id":"%s","human":"%s","ai":"%s"}\n' "$id" "$hout" "$aout" >>"$JSONL"
  cp "$ORIG" "$PROD"
  verify_prod
done

echo "DONE"
shasum -a 256 "$PROD"
