// Original discrete-time constant-hazard template adapted from cat_adoptions.
// event=1: adoption at day time>=1; event=0: no adoption through day time.
// censor_day is a known administrative deadline used to replicate observed records.
data {
  int<lower=1> N;
  int<lower=1> J;
  array[N] int<lower=1, upper=J> group;
  array[N] int<lower=0> time;
  array[N] int<lower=0, upper=1> event;
  array[N] int<lower=0> censor_day;
  real<lower=0> prior_a;
  real<lower=0> prior_b;
  int<lower=0, upper=1> prior_only;
}
transformed data {
  if (prior_a <= 0 || prior_b <= 0) reject("Beta shapes must be strictly positive");
  for (n in 1:N) {
    if (event[n] && time[n] < 1) reject("Event day must be at least 1");
    if (time[n] > censor_day[n]) reject("Observed time exceeds censor deadline");
    if (!event[n] && time[n] != censor_day[n])
      reject("Censored time must equal administrative deadline");
  }
}
parameters { vector<lower=0, upper=1>[J] p; }
model {
  p ~ beta(prior_a, prior_b);
  if (!prior_only) {
    for (n in 1:N) {
      if (event[n]) {
        target += bernoulli_lpmf(1 | p[group[n]]);
        target += binomial_lpmf(0 | time[n] - 1, p[group[n]]);
      } else {
        target += binomial_lpmf(0 | time[n], p[group[n]]);
      }
    }
  }
}
generated quantities {
  vector[N] log_lik;
  array[N] int time_rep;
  array[N] int event_rep;
  for (n in 1:N) {
    real latent_day = 1 + floor(log1m(uniform_rng(0, 1)) / log1m(p[group[n]]));
    event_rep[n] = latent_day <= censor_day[n];
    time_rep[n] = event_rep[n] ? to_int(latent_day) : censor_day[n];
    if (event[n])
      log_lik[n] = bernoulli_lpmf(1 | p[group[n]]) +
                  binomial_lpmf(0 | time[n] - 1, p[group[n]]);
    else
      log_lik[n] = binomial_lpmf(0 | time[n], p[group[n]]);
  }
}
