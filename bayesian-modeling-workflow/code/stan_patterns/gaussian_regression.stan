// Original template adapted from digits/linear.stan and sleep-study workflow.
// X excludes the intercept; all prior scales are supplied in coefficient units.
data {
  int<lower=1> N;
  int<lower=1> P;
  matrix[N, P] X;
  vector[N] y;
  real alpha_prior_mean;
  real<lower=0> alpha_prior_sd;
  vector<lower=0>[P] beta_prior_sd;
  real<lower=0> sigma_prior_scale;
  int<lower=0, upper=1> prior_only;
}
transformed data {
  if (alpha_prior_sd <= 0 || min(beta_prior_sd) <= 0 || sigma_prior_scale <= 0)
    reject("All prior scales must be strictly positive");
}
parameters {
  real alpha;
  vector[P] beta;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(alpha_prior_mean, alpha_prior_sd);
  beta ~ normal(0, beta_prior_sd);
  sigma ~ normal(0, sigma_prior_scale);
  if (!prior_only) y ~ normal(alpha + X * beta, sigma);
}
generated quantities {
  vector[N] mu = alpha + X * beta;
  vector[N] log_lik;
  vector[N] y_rep;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | mu[n], sigma);
    y_rep[n] = normal_rng(mu[n], sigma);
  }
}
