// Toy SBC contract: mu ~ Normal(0,2), y | mu ~ Normal(mu,1).
data {
  int<lower=1> N;
  vector[N] y;
}
parameters {
  real mu;
}
model {
  mu ~ normal(0, 2);
  y ~ normal(mu, 1);
}
generated quantities {
  vector[N] log_lik;
  real lprior = normal_lpdf(mu | 0, 2);
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | mu, 1);
  }
}
