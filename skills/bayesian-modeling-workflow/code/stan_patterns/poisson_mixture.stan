// Original pointwise mixture idiom adapted from corrected sbc/models/mixture_fixed_log_mix.stan and combined_first.stan.
// Component rates have exchangeable lognormal priors, then an ordering convention.
data {
  int<lower=1> N;
  int<lower=1> P;
  matrix[N, P] X;
  array[N] int<lower=0> y;
  real log_mu_prior_mean;
  real<lower=0> log_mu_prior_sd;
  real<lower=0> beta_prior_sd;
  int<lower=0, upper=1> prior_only;
}
transformed data {
  if (log_mu_prior_sd <= 0 || beta_prior_sd <= 0)
    reject("All prior scales must be strictly positive");
}
parameters {
  positive_ordered[2] mu;
  vector[P] beta;
}
model {
  mu ~ lognormal(log_mu_prior_mean, log_mu_prior_sd);
  beta ~ normal(0, beta_prior_sd);
  if (!prior_only) {
    for (n in 1:N) {
      real theta = inv_logit(X[n] * beta);
      target += log_mix(theta, poisson_lpmf(y[n] | mu[1]),
                              poisson_lpmf(y[n] | mu[2]));
    }
  }
}
generated quantities {
  vector[N] log_lik;
  array[N] int y_rep;
  for (n in 1:N) {
    real theta = inv_logit(X[n] * beta);
    log_lik[n] = log_mix(theta, poisson_lpmf(y[n] | mu[1]),
                               poisson_lpmf(y[n] | mu[2]));
    y_rep[n] = bernoulli_rng(theta) ? poisson_rng(mu[1]) : poisson_rng(mu[2]);
  }
}
