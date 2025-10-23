# Clustering Algorithms and Statistical Methods

Clustering algorithms detect structured regions of varying size and compactness, while statistical methods evaluate overrepresentation of biological terms within these regions. The choice of algorithm or test depends on network scale, density, and biological context, influencing the resolution, granularity, and rigor of the resulting modules and overrepresentation results.

---

## Summary of Clustering Algorithms

Before applying statistical tests, RISK groups nodes into modules using community detection. Each algorithm has strengths for different network sizes and contexts.

| Algorithm         | Speed  | Primary use                                | When/Why (assumptions & notes)                                                                                                        |
| ----------------- | ------ | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| Louvain           | Fast   | Default, scalable to very large networks   | Greedy modularity optimization (Blondel _et al_., 2008); efficient for >10⁴ nodes; may produce disconnected subclusters.                |
| Leiden            | Fast   | Improved Louvain with better resolution    | Guarantees well-connected communities; more stable than Louvain (Traag _et al_., 2019); slightly higher runtime.                        |
| Markov Clustering | Medium | Detect smaller, compact complexes          | Flow-based algorithm (Van Dongen, 2008); good for protein complexes or tightly connected submodules.                                  |
| Walktrap          | Medium | Hierarchical detection in mid-sized graphs | Random-walk based (Pons & Latapy, 2005); effective for local structure; slower on >10⁴ nodes.                                         |
| Greedy Modularity | Fast   | Coarse partitioning                        | Optimizes modularity via agglomeration; very fast but suffers from resolution limit (Newman, 2004).                                   |
| Label Propagation | Fast   | Quick heuristic                            | Unsupervised label spreading; no objective function; non-deterministic and unstable (Raghavan _et al_., 2007).                          |
| Spinglass         | Slow   | Small networks; theoretical interest       | Statistical mechanics approach (Reichardt & Bornholdt, 2006); finds communities by simulating spin states; computationally intensive. |

### Choosing an algorithm: quick guidance

- For large networks (>10⁴ nodes): **Louvain** or **Leiden** (fast, scalable).
- For small, compact complexes: **Markov Clustering** (protein complexes, submodules).
- For hierarchical/local structure: **Walktrap** (medium size).
- For exploratory speed: **Greedy** or **Label Propagation** (but less precise).
- For research/theory on small graphs: **Spinglass** (rarely used in practice).

---

## Summary of Statistical Methods

RISK implements a suite of statistical tests—ranging from fast approximations to rigorous overrepresentation analysis—to assess functional term overrepresentation in network neighborhoods. Each method has strengths depending on dataset size, structure, and precision requirements.

| Test           | Speed  | Primary use                                | When/Why (assumptions & notes)                                                                                                   |
| -------------- | ------ | ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| Permutation    | Medium | Most rigorous; non-parametric              | Distribution-free empirical null (permute network or labels); preferred when assumptions are unclear; computationally intensive. |
| Hypergeometric | Medium | Standard for GO/pathway overrepresentation | Exact test for finite populations sampled without replacement; widely used for term–to–gene membership tables.                   |
| Chi-squared    | Fast   | Approximate contingency-table testing      | Suitable for large samples with expected counts ≥ 5 per cell; fast but approximate; avoid with sparse/low counts.                |
| Binomial       | Fast   | Scalable approximation                     | Fast approximation assuming independent trials/with-replacement; useful for large populations with small samples.                |

### Choosing a test: quick guidance

- For rigorous overrepresentation analysis with minimal assumptions: use **Permutation** or **Hypergeometric**.
- For large samples with many categories and sufficient counts: **Chi-squared** offers a fast approximate test.
- For speed and scalability with large populations and small samples: use **Binomial** as a practical approximation.

## Shared Parameters

Shared parameters among statistical methods.

- `network` (nx.Graph): The network graph.
- `annotation` (dict): The annotation associated with the network.
- `clustering` (str, list, tuple, or np.ndarray, optional): Community detection algorithm(s) used to partition the network into clusters (neighborhoods). Provide a single algorithm or a list/tuple/array to run multiple algorithms. Options include:
    - `'louvain'`: Applies the Louvain method for community detection. _(default)_
    - `'greedy'`: Detects communities in a graph based on the greedy optimization of modularity.
    - `'labelprop'`: Uses label propagation to find communities.
    - `'leiden'`: Applies the Leiden method for community detection.
    - `'markov'`: Implements the Markov Clustering Algorithm.
    - `'walktrap'`: Detects communities via random walks.
    - `'spinglass'`: Community detection based on the spinglass model.
- `louvain_resolution` (float, optional): Resolution parameter for the Louvain method. Only applies if `'louvain'` is selected via `clustering`. Defaults to 0.1.
- `leiden_resolution` (float, optional): Resolution parameter for the Leiden method. Only applies if `'leiden'` is selected via `clustering`. Defaults to 1.0.
- `fraction_shortest_edges` (float, list, tuple, or np.ndarray, optional): Shortest edge rank fraction threshold(s) for creating subgraphs. Can be a single float for one threshold or a list/tuple of floats corresponding to multiple thresholds. Defaults to 0.5.
- `null_distribution` (str, optional): Defines the type of null distribution to use for comparison. Options include:
    - `'network'`: Randomly permuted network structure. _(default)_
    - `'annotation'`: Randomly permuted annotations.
- `random_seed` (int, optional): Seed for random number generation in permutation test. Defaults to 888.

---

## Permutation Test

Builds an empirical null by permuting either the network structure or annotation labels.

**When to use:**

- Non-parametric and distribution-free; ideal when analytical assumptions (independence, variance, distribution) are doubtful.
- Supports flexible nulls (permute network topology or term labels) to match study design.
- Most rigorous option but computationally intensive; prefer for smaller networks or final confirmation analyses.

**Additional Parameters:**

- `score_metric` (str, optional): Metric used to score neighborhoods. Options include: - `'sum'`: Sums the annotation values within each neighborhood. _(default)_ - `'stdev'`: Computes the standard deviation of annotation values within each neighborhood.
- `num_permutations` (int, optional): Number of permutations for significance testing. Defaults to 1000.
- `max_workers` (int, optional): Maximum number of workers for parallel computation. Defaults to 1.

**Returns:**
`dict`: A dictionary containing the computed significance of neighborhoods within the network.

```python
neighborhoods = risk.load_neighborhoods_permutation(
    network=network,
    annotation=annotation,
    clustering="louvain",
    louvain_resolution=0.1,
    fraction_shortest_edges=0.5,
    score_metric="sum",
    null_distribution="network",
    num_permutations=1000,
    random_seed=888,
    max_workers=1,
)
```

---

## Hypergeometric Test

Exact test based on finite sampling without replacement.

**When to use:**

- Standard for GO/pathway overrepresentation with term–to–gene membership tables.
- Appropriate for finite populations sampled without replacement (e.g., selected cluster vs whole network).
- Exact test; more accurate than approximations when sample is not negligible relative to the population.

**Returns:**
`dict`: A dictionary containing the computed significance of neighborhoods within the network.

```python
neighborhoods = risk.load_neighborhoods_hypergeom(
    network=network,
    annotation=annotation,
    clustering="louvain",
    louvain_resolution=0.1,
    fraction_shortest_edges=0.5,
    null_distribution="network",
    random_seed=888,
)
```

---

## Chi-squared Test

Evaluates significance using contingency tables.

**When to use:**

- Suitable for large-sample contingency analyses across multiple categories.
- Rule of thumb: expected counts per cell should be ≥ 5; avoid with sparse tables.
- Fast and scalable but approximate; consider permutation or exact tests for sparse data.

**Returns:**
`dict`: A dictionary containing the computed significance of neighborhoods within the network.

```python
neighborhoods = risk.load_neighborhoods_chi2(
    network=network,
    annotation=annotation,
    clustering="louvain",
    louvain_resolution=0.1,
    fraction_shortest_edges=0.5,
    null_distribution="network",
    random_seed=888,
)
```

---

## Binomial Test

Fast approximation to overrepresentation based on independent trials.

**When to use:**

- Provides a scalable approximation to the hypergeometric test, assuming independent trials or sampling with replacement.
- Useful for very large populations with small samples where exact tests are computationally costly.
- Offers speed and scalability while being less precise than exact methods.

**Returns:**
`dict`: A dictionary containing the computed significance of neighborhoods within the network.

```python
neighborhoods = risk.load_neighborhoods_binom(
    network=network,
    annotation=annotation,
    clustering="louvain",
    louvain_resolution=0.1,
    fraction_shortest_edges=0.5,
    null_distribution="network",
    random_seed=888,
)
```

---

## Next Step

[Building and Analyzing Networks](5_analyzing_results.md)
