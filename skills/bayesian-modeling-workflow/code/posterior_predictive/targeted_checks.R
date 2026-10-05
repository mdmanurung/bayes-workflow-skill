# Pure data check; returns observed and replicated summary values.
# y_rep rows are datasets; choose stat for the scientifically relevant assumption.
check_statistic <- function(y, y_rep, stat) {
  stopifnot(is.numeric(y), all(is.finite(y)), is.matrix(y_rep),
            is.numeric(y_rep), ncol(y_rep) == length(y), nrow(y_rep) > 0L,
            all(is.finite(y_rep)), is.function(stat))
  observed <- stat(y)
  replicated <- apply(y_rep, 1L, stat)
  list(observed = observed, replicated = replicated)
}
# Examples after supplying y and y_rep:
# check_statistic(y, y_rep, function(z) mean(z == 0))
# check_statistic(y, y_rep, function(z) quantile(z, 0.95, names = FALSE))
