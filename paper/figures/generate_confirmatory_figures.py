#!/usr/bin/env python3
"""Generate confirmatory-phase (E11-E15) figures for the paper.

Data source of truth: research/confirmatory-e11-e15.csv
Produces (numbered to match in-text figure order in paper_revised.md/.tex):
  figure4_confirmatory_mutation_scores.png
  figure5_confirmatory_paired_differences.png
  figure6_confirmatory_coverage_dissociation.png
"""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

OUT = "/Users/premalmistry/Desktop/Projects/beyond-code-coverage-ai-vs-human-tests/paper/figures"

exps = ["E11", "E12", "E13", "E14", "E15"]
human_ms = [41.7, 90.9, 91.3, 68.2, 54.2]
ai_ms = [91.7, 95.5, 100.0, 72.7, 66.7]
diff = [a - h for a, h in zip(ai_ms, human_ms)]

# ---------------------------------------------------------------------------
# Figure 4: Confirmatory mutation scores (E11-E15), human vs AI
# ---------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(6, 3.6))
x = np.arange(len(exps))
w = 0.35
ax.bar(x - w / 2, human_ms, width=w, label="Human", color="#4C72B0")
ax.bar(x + w / 2, ai_ms, width=w, label="AI", color="#DD8452")
for i, (h, a) in enumerate(zip(human_ms, ai_ms)):
    ax.text(i - w / 2, h + 1.5, f"{h:.1f}", ha="center", va="bottom", fontsize=8)
    ax.text(i + w / 2, a + 1.5, f"{a:.1f}", ha="center", va="bottom", fontsize=8)
ax.set_xticks(x)
ax.set_xticklabels(exps)
ax.set_ylabel("Mutation score (%)")
ax.set_ylim(0, 112)
ax.set_title("Confirmatory phase (E11\u2013E15): mutation score by suite")
ax.legend(loc="lower right", frameon=False)
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
fig.tight_layout()
fig.savefig(f"{OUT}/figure4_confirmatory_mutation_scores.png", dpi=200)
plt.close(fig)

# ---------------------------------------------------------------------------
# Figure 5: Confirmatory coverage/mutation dissociation cases (E13, E15, E14)
# Each panel: grouped bars of line coverage vs mutation score, Human vs AI.
# ---------------------------------------------------------------------------
cases = {
    "E13\n(identical line coverage)": {
        "human_cov": 92.95, "ai_cov": 92.95,
        "human_ms": 91.3, "ai_ms": 100.0,
    },
    "E15\n(inverse ranking)": {
        "human_cov": 71.19, "ai_cov": 44.92,
        "human_ms": 54.2, "ai_ms": 66.7,
    },
    "E14\n(large cov. gap, small MS gap)": {
        "human_cov": 47.62, "ai_cov": 79.76,
        "human_ms": 68.2, "ai_ms": 72.7,
    },
}

fig, axes = plt.subplots(1, 3, figsize=(9.5, 3.6), sharey=True)
metrics = ["Line coverage", "Mutation score"]
for ax, (label, d) in zip(axes, cases.items()):
    vals_h = [d["human_cov"], d["human_ms"]]
    vals_a = [d["ai_cov"], d["ai_ms"]]
    xm = np.arange(2)
    wm = 0.35
    ax.bar(xm - wm / 2, vals_h, width=wm, label="Human", color="#4C72B0")
    ax.bar(xm + wm / 2, vals_a, width=wm, label="AI", color="#DD8452")
    for i, (h, a) in enumerate(zip(vals_h, vals_a)):
        ax.text(i - wm / 2, h + 1.5, f"{h:.1f}", ha="center", va="bottom", fontsize=7.5)
        ax.text(i + wm / 2, a + 1.5, f"{a:.1f}", ha="center", va="bottom", fontsize=7.5)
    ax.set_xticks(xm)
    ax.set_xticklabels(metrics, fontsize=8)
    ax.set_title(label, fontsize=9)
    ax.set_ylim(0, 112)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
axes[0].set_ylabel("Percent")
axes[0].legend(loc="lower left", frameon=False, fontsize=8)
fig.suptitle("Confirmatory phase: line coverage vs. mutation score, per suite", y=1.02)
fig.tight_layout()
fig.savefig(f"{OUT}/figure6_confirmatory_coverage_dissociation.png", dpi=200, bbox_inches="tight")
plt.close(fig)

# ---------------------------------------------------------------------------
# Figure 6: Confirmatory paired mutation-score difference (AI - Human)
# ---------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(6, 3.2))
colors = ["#DD8452" if d >= 0 else "#4C72B0" for d in diff]
bars = ax.bar(exps, diff, color=colors)
for b, d in zip(bars, diff):
    ax.text(b.get_x() + b.get_width() / 2, d + 1, f"+{d:.1f}", ha="center", va="bottom", fontsize=8)
ax.axhline(0, color="black", linewidth=0.8)
ax.set_ylabel("AI \u2212 Human mutation score (pp)")
ax.set_title("Confirmatory phase (E11\u2013E15): paired mutation-score difference")
ax.set_ylim(0, 58)
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
fig.tight_layout()
fig.savefig(f"{OUT}/figure5_confirmatory_paired_differences.png", dpi=200)
plt.close(fig)

print("Wrote figure4, figure5, figure6 to", OUT)
