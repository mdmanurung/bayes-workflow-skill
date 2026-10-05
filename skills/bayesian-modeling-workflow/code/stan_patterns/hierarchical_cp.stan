// Original correlated varying-intercept/slope template, column-wise centered effects.
// See movies, sleep_study and park_rule; CP/NCP is an empirical choice.
data {
  int<lower=1> N;
  int<lower=1> J;
  array[N] int<lower=1, upper=J> group;
  vector[N] x;
  vector[N] y;
  real alpha_prior_mean;
  real<lower=0> alpha_prior_sd;
  real<lower=0> beta_prior_sd;
  vector<lower=0>[2] tau_prior_scale;
  real<lower=0> sigma_prior_scale;
  real<lower=0> lkj_shape;
  int<lower=0, upper=1> prior_only;
}
transformed data {
  if (alpha_prior_sd <= 0 || beta_prior_sd <= 0 || min(tau_prior_scale) <= 0 ||
      sigma_prior_scale <= 0 || lkj_shape <= 0)
    reject("All prior scales/shapes must be strictly positive");
}
parameters {
  real alpha;
  real beta;
  vector<lower=0>[2] tau;
  cholesky_factor_corr[2] L;
  matrix[2, J] b;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(alpha_prior_mean, alpha_prior_sd);
  beta ~ normal(0, beta_prior_sd);
  tau ~ normal(0, tau_prior_scale);
  L ~ lkj_corr_cholesky(lkj_shape);
  for (j in 1:J)
    b[, j] ~ multi_normal_cholesky(rep_vector(0, 2), diag_pre_multiply(tau, L));
  sigma ~ normal(0, sigma_prior_scale);
  if (!prior_only) {
    for (n in 1:N)
      y[n] ~ normal(alpha + b[1, group[n]] +
                    (beta + b[2, group[n]]) * x[n], sigma);
  }
}
generated quantities {
  corr_matrix[2] Omega = multiply_lower_tri_self_transpose(L);
  cov_matrix[2] Sigma = quad_form_diag(Omega, tau);
  vector[N] log_lik;
  vector[N] y_rep;
  for (n in 1:N) {
    real mu = alpha + b[1, group[n]] + (beta + b[2, group[n]]) * x[n];
    log_lik[n] = normal_lpdf(y[n] | mu, sigma);
    y_rep[n] = normal_rng(mu, sigma);
  }
}
