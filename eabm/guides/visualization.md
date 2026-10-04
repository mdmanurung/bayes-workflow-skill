# Use figures to discriminate between explanations

Choose a visual by the question and the audience. A figure should show the feature that could contradict the current explanation, with units, conditioning and uncertainty visible. Design quality cannot compensate for an inappropriate statistical quantity.

| Question | Useful visual | Interpretive check |
|---|---|---|
| Do chains explore alike? | Trace/rank plots by chain | Keep chain encodings consistent; show transitions, separation and relevant tails |
| Where does geometry fail? | Divergence-marked pairs/parallel coordinates | Include group scales/log transforms; avoid thousands of unreadable pair panels |
| Is a distribution skewed/multimodal? | ECDF, density/dots and intervals | KDE can obscure discrete support or invent boundary mass; show modes rather than one symmetric error bar |
| Is a prior plausible? | Predictive quantiles/extremes at design points | Use domain reference ranges, units and group variation |
| Which feature fails PPC? | Replicated statistic distributions, rootograms, group/time panels | Observed reference visible; same statistic/design for replications; noisy outcomes rather than epred |
| Which assumptions affect a conclusion? | Matched quantity/interval or power curves with MCSE | Separate posterior uncertainty from numerical uncertainty; only plot validated importance ranges |
| What drives predictive differences? | Paired unitwise differences with covariates/group IDs | Diagnose influence and heterogeneous tasks rather than relying on a ranking bar |
| How uncertain is a scientific contrast? | Contrast distribution, interval or quantile/dot plot | Name interval kind/mass, scale and population; avoid false precision and unsupported causal labels |

Use clear axis labels, nonmisleading limits, accessible palettes and consistent model/chain colors. Avoid decorative 3D, repeated legends, tiny facets and precision implying more information than the model supports. Log scales need interpretable labels and correct transformed densities. A credible interval and a predictive interval refer to different quantities; name them.

Python: ArviZ's current plot collections plus matplotlib for a targeted derived statistic. R: bayesplot for diagnostics/PPC, ggdist/tidybayes for appropriately weighted posterior/derived quantities. Defaults differ across packages; set interval type/mass deliberately. Projection clusters or model mixtures may require weights; do not plot them as ordinary equally weighted parameter draws without checking meaning.

Evidence: E01/E03/E14 (`direct-eabm`), M-VIS/M-PPC (`method-paper`); task table and R routes `synthesized`/`translated`. Package links: D-AZ-PLOTS, D-BAYESPLOT, D-TIDYBAYES, D-GGDIST. This guide supplements [reporting](reporting.md) and does not replace targeted diagnostic modules.
