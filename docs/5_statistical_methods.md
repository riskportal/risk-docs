# Statistical Methods

Once clusters are defined, statistical tests quantify the enrichment or depletion of annotation terms within those modules. Each test returns a dictionary with `"depletion_pvals"` and `"enrichment_pvals"` matrices aligned to the cluster matrix supplied as input.

---

## Summary of Statistical Methods

| Test           | Speed  | Primary use                                | When/Why (assumptions & notes)                                                                                                   |
| -------------- | ------ | ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| Permutation    | Slow   | Most rigorous; non-parametric              | Distribution-free empirical null (permute network or labels); preferred when assumptions are unclear; computationally intensive. |
| Hypergeometric | Medium | Standard for GO/pathway overrepresentation | Exact test for finite populations sampled without replacement; widely used for term–to–gene membership tables.                   |
| Chi-squared    | Fast   | Approximate contingency-table testing      | Suitable for large samples with expected counts ≥ 5 per cell; fast but approximate; avoid with sparse/low counts.                |
| Binomial       | Fast   | Scalable approximation                     | Fast approximation assuming independent trials/with-replacement; useful for large populations with small samples.                |

### Choosing a test: quick guidance

- For rigorous overrepresentation analysis with minimal assumptions: use **Permutation** or **Hypergeometric**.
- For large samples with many categories and sufficient counts: **Chi-squared** offers a fast approximate test.
- For speed and scalability with large populations and small samples: use **Binomial** as a practical approximation.

---

## Permutation Test

Builds an empirical null by permuting either the network structure or annotation labels.

**When to use:**

- Most rigorous option when assumptions about the data distribution are unclear.
- Generates an empirical null distribution by repeatedly permuting the network or annotations.
- Computationally intensive but unbiased.

**Parameters:**

- `annotation` (dict): The annotation dictionary.
- `clusters` (csr_matrix): The cluster-assignment matrix.
- `score_metric` (str, optional): Metric used to score clusters (`"sum"` or `"stdev"`). Defaults to `"sum"`.
- `null_distribution` (str, optional): Permute `"network"` or `"annotation"`. Defaults to `"network"`.
- `num_permutations` (int, optional): Number of permutations to run. Defaults to `1000`.
- `max_workers` (int, optional): Maximum worker processes for multiprocessing. Defaults to `1`.

**Returns:**
`dict`: A dictionary with `"depletion_pvals"` and `"enrichment_pvals"` matrices.

```python
stats_permutation = risk.run_permutation(
    annotation=annotation,
    clusters=clusters_louvain,
    score_metric="stdev",
    null_distribution="network",
    num_permutations=1_000,
    random_seed=888,
    max_workers=4,
)
```

---

## Hypergeometric Test

Exact test based on finite sampling without replacement.

**When to use:**

- Canonical method for GO/pathway overrepresentation.
- Exact and statistically interpretable for moderate-sized networks.

**Parameters:**

- `annotation` (dict): Annotation dictionary containing ordered nodes and annotation matrix.
- `clusters` (csr_matrix): Cluster-assignment matrix produced by a `cluster_*` method.
- `null_distribution` (str, optional): Permute `"network"` or `"annotation"`. Defaults to `"network"`.

**Returns:**
`dict`: A dictionary with `"depletion_pvals"` and `"enrichment_pvals"` matrices.

```python
stats_hypergeom = risk.run_hypergeom(
    annotation=annotation,
    clusters=clusters_louvain,
    null_distribution="network",
)
```

---

## Chi-squared Test

Evaluates significance using contingency tables.

**When to use:**

- Suitable for large-sample contingency analyses across multiple categories.
- Rule of thumb: expected counts per cell should be ≥ 5; avoid with sparse tables.
- Fast and scalable but approximate; consider permutation or exact tests for sparse data.

**Parameters:**

- `annotation` (dict): Annotation dictionary containing ordered nodes and annotation matrix.
- `clusters` (csr_matrix): Cluster-assignment matrix produced by a `cluster_*` method.
- `null_distribution` (str, optional): Permute `"network"` or `"annotation"`. Defaults to `"network"`.

**Returns:**
`dict`: A dictionary with `"depletion_pvals"` and `"enrichment_pvals"` matrices.

```python
stats_chi2 = risk.run_chi2(
    annotation=annotation,
    clusters=clusters_louvain,
    null_distribution="network",
)
```

---

## Binomial Test

Fast approximation to overrepresentation based on independent trials.

**When to use:**

- Provides a scalable approximation to the hypergeometric test, assuming independent trials or sampling with replacement.
- Useful for very large populations with small samples where exact tests are computationally costly.

**Parameters:**

- `annotation` (dict): Annotation dictionary containing ordered nodes and annotation matrix.
- `clusters` (csr_matrix): Cluster-assignment matrix produced by a `cluster_*` method.
- `null_distribution` (str, optional): Permute `"network"` or `"annotation"`. Defaults to `"network"`.

**Returns:**
`dict`: A dictionary with `"depletion_pvals"` and `"enrichment_pvals"` matrices.

```python
stats_binom = risk.run_binom(
    annotation=annotation,
    clusters=clusters_louvain,
    null_distribution="network",
)
```

---

## Next Step

[Building and Analyzing Networks](6_analyzing_results.md)
