# Batch fit wrapper for SLURM or the shell. Writes CmdStan CSVs, fit.rds and versions.txt to --out.
# Usage: Rscript run_fit.R --model m.stan --data d.json --out DIR --seed N
#        [--chains 4] [--threads 1] [--warmup 1000] [--sampling 1000]
args <- commandArgs(trailingOnly = TRUE)
opt <- list(chains = "4", threads = "1", warmup = "1000", sampling = "1000")
for (i in seq(1, length(args), by = 2)) opt[[sub("^--", "", args[i])]] <- args[i + 1]
missing <- setdiff(c("model", "data", "out", "seed"), names(opt))
if (length(missing)) stop("missing required args: ", paste0("--", missing, collapse = " "))

threads <- as.integer(opt$threads)
chains <- as.integer(opt$chains)
dir.create(opt$out, recursive = TRUE, showWarnings = FALSE)

cpp <- if (threads > 1) list(stan_threads = TRUE) else list()
mod <- cmdstanr::cmdstan_model(opt$model, pedantic = TRUE, cpp_options = cpp)
fit <- mod$sample(
  data = opt$data, seed = as.integer(opt$seed),
  chains = chains, parallel_chains = chains,
  threads_per_chain = if (threads > 1) threads else NULL,
  iter_warmup = as.integer(opt$warmup), iter_sampling = as.integer(opt$sampling),
  output_dir = opt$out
)
fit$save_object(file.path(opt$out, "fit.rds"))

writeLines(c(
  paste("args:", paste(args, collapse = " ")),
  paste("model_md5:", unname(tools::md5sum(opt$model))),
  paste("data_md5:", unname(tools::md5sum(opt$data))),
  paste("cmdstan:", cmdstanr::cmdstan_version()),
  paste("slurm_job_id:", Sys.getenv("SLURM_JOB_ID", "none")),
  paste("date:", format(Sys.time(), "%F %T %Z")),
  "", capture.output(sessionInfo())
), file.path(opt$out, "versions.txt"))
fit$diagnostic_summary()
