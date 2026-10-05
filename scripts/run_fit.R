# Batch fit wrapper for SLURM or the shell. Writes CmdStan CSVs, fit.rds and versions.txt to --out.
# Usage: Rscript run_fit.R --model m.stan --data d.json --out DIR --seed N
#        [--chains 4] [--threads 1] [--warmup 1000] [--sampling 1000]
args <- commandArgs(trailingOnly = TRUE)
opt <- list(chains = "4", threads = "1", warmup = "1000", sampling = "1000")
if (length(args) %% 2) stop("flags must come in --name value pairs")
for (i in seq(1, length(args), by = 2)) opt[[sub("^--", "", args[i])]] <- args[i + 1]
missing <- setdiff(c("model", "data", "out", "seed"), names(opt))
if (length(missing)) stop("missing required args: ", paste0("--", missing, collapse = " "))
unknown <- setdiff(names(opt), c("model", "data", "out", "seed", "chains", "threads", "warmup", "sampling"))
if (length(unknown)) stop("unknown args: ", paste0("--", unknown, collapse = " "))
if (!grepl("\\.stan$", opt$model)) stop("--model must be a .stan file (the exe name is derived from it): ", opt$model)
int_arg <- function(name) {
  val <- as.integer(opt[[name]])
  if (is.na(val) || val < 1) stop("--", name, " must be a positive integer, got: ", opt[[name]])
  val
}
seed <- as.integer(opt$seed)
if (is.na(seed)) stop("--seed must be an integer below 2^31")
chains <- int_arg("chains"); threads <- int_arg("threads")
warmup <- int_arg("warmup"); sampling <- int_arg("sampling")

if (length(list.files(opt$out, "\\.csv$"))) stop(opt$out, " already has CSVs; use a fresh --out so chains from different runs are not mixed")
dir.create(opt$out, recursive = TRUE, showWarnings = FALSE)

# Version record written before sampling so a killed fit still leaves one;
# rewritten with sessionInfo() after the fit completes.
vers <- c(
  paste("args:", paste(args, collapse = " ")),
  paste("model_md5:", unname(tools::md5sum(opt$model))),
  paste("data_md5:", unname(tools::md5sum(opt$data))),
  paste("cmdstan:", cmdstanr::cmdstan_version()),
  paste("slurm_job_id:", Sys.getenv("SLURM_JOB_ID", "none")),
  paste("date:", format(Sys.time(), "%F %T %Z"))
)
writeLines(vers, file.path(opt$out, "versions.txt"))

cpp <- if (threads > 1) list(stan_threads = TRUE) else list()
# Separate binary for threaded builds: cmdstanr reuses an up-to-date exe even when cpp_options differ.
exe <- sub("\\.stan$", if (threads > 1) "_threads" else "", opt$model)
mod <- cmdstanr::cmdstan_model(opt$model, exe_file = exe, pedantic = TRUE, cpp_options = cpp)
fit <- mod$sample(
  data = opt$data, seed = seed,
  chains = chains, parallel_chains = chains,
  threads_per_chain = if (threads > 1) threads else NULL,
  iter_warmup = warmup, iter_sampling = sampling,
  output_dir = opt$out
)
fit$save_object(file.path(opt$out, "fit.rds"))

writeLines(c(vers, "", capture.output(sessionInfo())), file.path(opt$out, "versions.txt"))
fit$diagnostic_summary()
