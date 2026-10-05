# Screen a saved MCMC fit from disk: R-hat, ESS, divergences, treedepth, E-BFMI.
# Usage: Rscript check_saved_fit.R PATH [--vars a,b] [--max-treedepth 10]
#   PATH: directory of CmdStan CSVs, or .rds holding a CmdStanMCMC or brmsfit.
# Cutoffs come from skills/eabm/references/thresholds.json. Passing is screening, not proof of convergence.
# Exit status: 0 = no flags, 1 = flags printed (or an R error, which prints "Error").
args <- commandArgs(trailingOnly = TRUE)
if (!length(args)) stop("usage: Rscript check_saved_fit.R PATH [--vars a,b] [--max-treedepth 10]")
path <- args[1]
opt <- list()
if (length(args) %% 2 == 0) stop("flags must come in --name value pairs after PATH")
if (length(args) > 1) for (i in seq(2, length(args), by = 2)) opt[[sub("^--", "", args[i])]] <- args[i + 1]
unknown <- setdiff(names(opt), c("vars", "max-treedepth"))
if (length(unknown)) stop("unknown args: ", paste0("--", unknown, collapse = " "))

script_dir <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))))
th_file <- file.path(script_dir, "..", "skills", "eabm", "references", "thresholds.json")
if (!file.exists(th_file)) stop("thresholds.json not found at ", th_file, "; run this script from the plugin's scripts/ dir")
th <- jsonlite::fromJSON(th_file)

if (dir.exists(path)) {
  csvs <- list.files(path, "\\.csv$", full.names = TRUE)
  csvs <- csvs[vapply(csvs, function(f) startsWith(readLines(f, n = 1), "#"), logical(1))]
  if (!length(csvs)) stop("no CmdStan CSVs in ", path)
  # Refuse CSVs from different runs: chains must share model and seed.
  # Data identity is not recorded in the CSV header, so same model+seed with
  # different data would pass; run_fit.R's --out guard prevents that mix.
  header <- function(f, key) grep(paste0("^#\\s*", key, " = "), readLines(f, n = 80), value = TRUE)[1]
  for (key in c("model", "seed")) {
    vals <- unique(vapply(csvs, header, character(1), key = key))
    if (length(vals) > 1) stop("CSVs in ", path, " come from different runs (", key, " differs): ", paste(vals, collapse = " | "))
  }
  obj <- cmdstanr::as_cmdstan_fit(csvs)
} else {
  obj <- readRDS(path)
}

if (inherits(obj, "CmdStanMCMC")) {
  draws <- obj$draws(format = "draws_array")
  sd <- posterior::as_draws_df(obj$sampler_diagnostics())
  diag <- data.frame(chain = sd$.chain, divergent = sd$divergent__, treedepth = sd$treedepth__, energy = sd$energy__)
  max_depth <- obj$metadata()$max_treedepth
} else if (inherits(obj, "brmsfit")) {
  draws <- posterior::as_draws_array(obj)
  np <- brms::nuts_params(obj)
  get <- function(p) np$Value[np$Parameter == p]
  diag <- data.frame(chain = np$Chain[np$Parameter == "divergent__"],
                     divergent = get("divergent__"), treedepth = get("treedepth__"), energy = get("energy__"))
  max_depth <- NULL
} else {
  stop("unsupported object class: ", paste(class(obj), collapse = "/"))
}
max_depth_assumed <- FALSE
if (!is.null(opt[["max-treedepth"]])) max_depth <- as.integer(opt[["max-treedepth"]])
if (is.null(max_depth)) {
  max_depth <- 10L  # ponytail: brms/Stan default; pass --max-treedepth if changed
  max_depth_assumed <- TRUE
}

if (!is.null(opt$vars)) draws <- posterior::subset_draws(draws, variable = strsplit(opt$vars, ",")[[1]])
draws <- posterior::subset_draws(draws, variable = setdiff(posterior::variables(draws), "lp__"))
n_chains <- posterior::nchains(draws)
summ <- posterior::summarise_draws(draws, "mean", "sd", "rhat", "ess_bulk", "ess_tail", "mcse_mean")

cat(sprintf("fit: %s | chains: %d | draws/chain: %d | variables: %d\n",
            path, n_chains, posterior::niterations(draws), nrow(summ)))
worst <- summ[order(-summ$rhat, summ$ess_bulk, na.last = FALSE), ]  # undefined-rhat rows first
print(as.data.frame(head(worst, 15)), digits = 3, row.names = FALSE)
if (nrow(summ) > 15) cat(sprintf("(showing worst 15 of %d by rhat)\n", nrow(summ)))

flags <- character()
first <- function(v) paste(head(v, 5), collapse = ", ")
bad_rhat <- summ$variable[!is.na(summ$rhat) & summ$rhat >= th$rhat$threshold]
if (length(bad_rhat)) flags <- c(flags, sprintf("rhat >= %s for %d variables: %s", th$rhat$threshold, length(bad_rhat), first(bad_rhat)))
undef <- summ$variable[is.na(summ$rhat)]
if (length(undef)) flags <- c(flags, sprintf("rhat undefined (constant?) for %d variables: %s", length(undef), first(undef)))
ess_min <- th$ess$threshold * n_chains
bad_ess <- summ$variable[which(pmin(summ$ess_bulk, summ$ess_tail) < ess_min)]
if (length(bad_ess)) flags <- c(flags, sprintf("ess_bulk/tail < %d (%d x %d chains) for %d variables: %s",
                                               ess_min, th$ess$threshold, n_chains, length(bad_ess), first(bad_ess)))
na_ess <- summ$variable[is.na(pmin(summ$ess_bulk, summ$ess_tail)) & !is.na(summ$rhat)]
if (length(na_ess)) flags <- c(flags, sprintf("ess_bulk/tail undefined for %d non-constant variables: %s",
                                              length(na_ess), first(na_ess)))
n_div <- sum(diag$divergent)
if (n_div > th$divergences$threshold) flags <- c(flags, sprintf("%d divergent transitions (%.2f%%)", n_div, 100 * mean(diag$divergent)))
n_td <- sum(diag$treedepth >= max_depth)
if (n_td) flags <- c(flags, sprintf("%d transitions hit max treedepth %d%s (efficiency, not validity)", n_td, max_depth,
                                    if (max_depth_assumed) " [assumed default; pass --max-treedepth if the fit used another]" else ""))
bfmi <- tapply(diag$energy, diag$chain, function(e) sum(diff(e)^2) / sum((e - mean(e))^2))
low <- names(bfmi)[bfmi < th$bfmi$threshold]
if (length(low)) flags <- c(flags, sprintf("E-BFMI < %s in chains %s", th$bfmi$threshold, paste(low, collapse = ", ")))

cat(sprintf("E-BFMI by chain: %s\n", paste(sprintf("%.2f", bfmi), collapse = " ")))
if (!length(flags)) {
  cat("OK: no screening flags. Screening only; still check PPC, sensitivity and MCSE for reported quantities.\n")
} else {
  cat(paste0("FLAG: ", flags, "\n"), sep = "")
  quit(status = 1)  # lets `check && next_step` stop on a flagged fit
}
