// Original adaptation of roaches/poisson_vi_integrate.stan.
// Fit observation-specific latent effects; integrate them only for held-out scores.
// Quadrature nodes/weights approximate expectations under a standard normal.
data {
  int<lower=1> N;
  int<lower=1> P;
  matrix[N, P] X;
  array[N] int<lower=0> y;
  vector[N] log_exposure;
  real alpha_prior_mean;
  real<lower=0> alpha_prior_sd;
  vector<lower=0>[P] beta_prior_sd;
  real<lower=0> sigma_prior_scale;
  int<lower=1> Q;
  vector[Q] quad_node;
  vector<lower=0>[Q] quad_weight;
  int<lower=0, upper=1> prior_only;
}
transformed data {
  if (alpha_prior_sd <= 0 || min(beta_prior_sd) <= 0 || sigma_prior_scale <= 0)
    reject("All prior scales must be strictly positive");
  if (abs(sum(quad_weight) - 1) > 1e-8)
    reject("Quadrature weights must sum to one");
}
parameters {
  real alpha;
  vector[P] beta;
  real<lower=0> sigma;
  vector[N] z;
}
model {
  alpha ~ normal(alpha_prior_mean, alpha_prior_sd);
  beta ~ normal(0, beta_prior_sd);
  sigma ~ normal(0, sigma_prior_scale);
  z ~ std_normal();
  if (!prior_only) y ~ poisson_log(alpha + X * beta + log_exposure + sigma * z);
}
generated quantities {
  vector[N] log_lik_cond;
  vector[N] log_lik;
  array[N] int y_rep_cond;
  array[N] int y_rep_new;
  for (n in 1:N) {
    real eta = alpha + X[n] * beta + log_exposure[n];
    vector[Q] lp;
    for (q in 1:Q)
      lp[q] = quad_weight[q] > 0 ?
        log(quad_weight[q]) + poisson_log_lpmf(y[n] | eta + sigma * quad_node[q]) :
        negative_infinity();
    log_lik[n] = log_sum_exp(lp);
    log_lik_cond[n] = poisson_log_lpmf(y[n] | eta + sigma * z[n]);
    y_rep_cond[n] = poisson_log_rng(eta + sigma * z[n]);
    y_rep_new[n] = poisson_log_rng(eta + normal_rng(0, sigma));
  }
}
