# Treat model implementation as scientific software

Basis: I01–I05 in [source map](source-map.md). Use small operations and interpretable model versions rather than an unnecessary framework.

## Incremental implementation

Begin with the smallest executable observation model. Check data dimensions, group indices, units, support, missing codes and predictor rank. Compile with pedantic warnings; distinguish missing explicit priors from deliberately proper constrained-support priors, and remove genuinely unused parameters.

Implement transforms and deterministic components before sampling complex latent structure. Test roundtrips, scales and signs. Add one component at a time, retaining a working version and its known-data test. Record model/data versions and scientific reasons, not only filenames.

Simulate fixed known parameters using an independent calculation. Compare selected likelihood terms with manual values, including constants needed for predictive scoring. Confirm priors appear exactly once; moving an intercept into a vector can accidentally duplicate its prior (SBC case). Match prior generator to bounds/order/latent covariance.

## Bug versus statistical inadequacy

| Observation | Competing explanation | Discriminating check |
|---|---|---|
| Systematic PPC shift | Wrong mean assumption or transform code | Independently calculate transform and inverse; compare predictions before/after roundtrip |
| Very narrow posterior | Strong evidence or repeated likelihood/double prior/ignored dependency | Count independent units; inspect loop/vectorization; known-data fit |
| Good recovery on easy data, unstable realistic fit | Identification or scale/tail geometry | Increase design information; vary realistic truths; inspect joint functions |
| Posterior equals prior | Uninformative data or unused parameter | Remove/change parameter in likelihood; inspect code and simulated contrast |
| Conditional PPC perfect, LOO fails | Observation-specific overfit or wrong held-out conditioning | Integrate held-out latent effect and compare refit |
| Numerical exceptions | Bad support/data/algorithm, not necessarily scientific misfit | Reproduce offending density at exact input; differentiate initialization from sampling |

## Edge cases worth testing

Use only cases relevant to the model: singleton/sparse groups; all-zero/all-one binary responses; zero/endpoint bounded counts; positive exposure and near-zero rates; missing emission components; empty/one-step tracks; boundary censoring times; ordered near-equal components; highly correlated design columns; large predictor values; solver tolerances and fast/slow dynamical regimes. In Stan avoid loops over `1:0`; guard loops that can be empty.

Use stable log-scale operations (`log1m`, `log_sum_exp`, `log_mix`, `log_diff_exp` or suitable CDF/CCDF formulations). A continuous density midpoint is not an exact discrete bin probability. Parameter-dependent truncation normalizers must be retained when defining a normalized conditional prior; an omitted constant is safe only if constant in all inferred parameters.

## Validate generated quantities

Check `y_rep`, `log_lik`, expected outcomes and scientific contrasts separately. A correct posterior fit can still have wrong predictions/scoring code. Dogs requires recursively generated histories; cats needs survival contributions; World Cup exposes a factor-of-two transform bug; correlated hierarchies need correct Cholesky orientation. Test that summed pointwise likelihood matches the intended observation likelihood and that prior-only runs exclude observed-response likelihood.

## Reproducibility and scope

Keep seed, chain starts, package/compiler versions, data transformations, observation IDs, settings and diagnostic outputs. Cache expensive simulation/fits with their inputs and failures. Do not carry local development paths, deprecated calls or corrected errors from historic code into new templates. Passing parse/compile validates syntax, not posterior accuracy. Passing synthetic checks validates the tested model domain, not the scientific measurement process.
