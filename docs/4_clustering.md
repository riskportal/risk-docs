# Clustering Algorithms

Clustering algorithms detect structured regions of varying size and compactness. The choice of algorithm depends on network scale, density, and biological context, influencing the resolution and stability of the resulting modules. Every clustering function in RISK accepts a `fraction_shortest_edges` argument—a rank-based fraction (0, 1] of the shortest edges retained before the algorithm runs—and returns a sparse cluster-assignment matrix (`csr_matrix`) that can be reused across multiple statistical tests.


---

## Algorithm Overview

| Algorithm         | Speed  | Primary use                                | When/Why (assumptions & notes)                                                                                                        |
| ----------------- | ------ | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| Louvain           | Fast   | Default, scalable to very large networks   | Greedy modularity optimization (Blondel _et al_., 2008); efficient for >10⁴ nodes; may produce disconnected subclusters.             |
| Leiden            | Fast   | Improved Louvain with better resolution    | Guarantees well-connected communities; more stable than Louvain (Traag _et al_., 2019); slightly higher runtime.                      |
| Markov Clustering | Medium | Detect smaller, compact complexes          | Flow-based algorithm (Van Dongen, 2008); good for protein complexes or tightly connected submodules.                                  |
| Walktrap          | Medium | Hierarchical detection in mid-sized graphs | Random-walk based (Pons & Latapy, 2005); effective for local structure; slower on >10⁴ nodes.                                         |
| Greedy Modularity | Fast   | Coarse partitioning                        | Optimizes modularity via agglomeration; very fast but suffers from resolution limit (Newman, 2004).                                   |
| Label Propagation | Fast   | Quick heuristic                            | Unsupervised label spreading; no objective function; non-deterministic and unstable (Raghavan _et al_., 2007).                        |
| Spinglass         | Slow   | Small networks; theoretical interest       | Statistical mechanics approach (Reichardt & Bornholdt, 2006); finds communities by simulating spin states; computationally intensive. |

### Choosing an algorithm: quick guidance

- For large networks (>10⁴ nodes): **Louvain** or **Leiden** (fast, scalable).
- For small, compact complexes: **Markov Clustering** (protein complexes, submodules).
- For hierarchical/local structure: **Walktrap** (medium size).
- For exploratory speed: **Greedy** or **Label Propagation** (but less precise).
- For research/theory on small graphs: **Spinglass** (rarely used in practice).

---

## Louvain Clustering

Greedy modularity optimization that scales well to large graphs and serves as the default starting point.

**When to use:**

- Large networks where speed and scalability are essential.
- Baseline clustering for downstream statistical comparisons.

**Parameters:**

- `network` (nx.Graph): The network to which the clustering is applied.
- `fraction_shortest_edges` (float): Rank-based edge filtering (0, 1]; defaults to `0.5`.
- `resolution` (float): Modularity resolution; lower values yield larger clusters. Defaults to `0.1`.
- `random_seed` (int): Seed for reproducibility. Defaults to `888`.

**Returns:**
`csr_matrix`: Sparse cluster-assignment matrix.

```python
clusters_louvain = risk.cluster_louvain(
    network=network,
    fraction_shortest_edges=0.25,
    resolution=0.5,
    random_seed=888,
)
```

---

## Leiden Clustering

Connectivity-refined variant of Louvain that produces better separated clusters while remaining fast.

**When to use:**

- You need Louvain-like speed but improved connectivity guarantees.
- Stability between repeated runs is important.

**Parameters:**

- `network` (nx.Graph): The network to which the clustering is applied.
- `fraction_shortest_edges` (float): Edge filtering fraction. Defaults to `0.5`.
- `resolution` (float): Resolution parameter; defaults to `1.0`.
- `random_seed` (int): Seed for reproducibility. Defaults to `888`.

**Returns:**
`csr_matrix`: Sparse cluster-assignment matrix.

```python
clusters_leiden = risk.cluster_leiden(
    network=network,
    fraction_shortest_edges=0.25,
    resolution=1.0,
    random_seed=888,
)
```

---

## Greedy Modularity Clustering

Agglomerative optimization that quickly produces coarse partitions—useful for exploratory analysis or as a lightweight baseline.

**When to use:**

- Rapid, coarse-grained partitions are sufficient.
- You want to benchmark other algorithms against a simple baseline.

**Parameters:**

- `network` (nx.Graph): The network to which the clustering is applied.
- `fraction_shortest_edges` (float): Edge filtering fraction. Defaults to `0.5`.

**Returns:**
`csr_matrix`: Sparse cluster-assignment matrix.

```python
clusters_greedy = risk.cluster_greedy(
    network=network,
    fraction_shortest_edges=0.25,
)
```

---

## Label Propagation Clustering

Heuristic label spreading approach that offers a non-parametric, fast partitioning of the network.

**When to use:**

- You need a parameter-free, extremely fast method.
- Exploratory analysis where minor instability is acceptable.

**Parameters:**

- `network` (nx.Graph): The network to which the clustering is applied.
- `fraction_shortest_edges` (float): Edge filtering fraction. Defaults to `0.5`.

**Returns:**
`csr_matrix`: Sparse cluster-assignment matrix.

```python
clusters_labelprop = risk.cluster_labelprop(
    network=network,
    fraction_shortest_edges=0.25,
)
```

---

## Markov Clustering (MCL)

Flow-based clustering that captures compact complexes by simulating random walks with expansion and inflation steps.

**When to use:**

- Detecting tight-knit protein complexes or submodules.
- Medium-sized networks where higher resolution structure is needed.

**Parameters:**

- `network` (nx.Graph): The network to which the clustering is applied.
- `fraction_shortest_edges` (float): Edge filtering fraction. Defaults to `0.5`.

**Returns:**
`csr_matrix`: Sparse cluster-assignment matrix.

```python
clusters_markov = risk.cluster_markov(
    network=network,
    fraction_shortest_edges=0.25,
)
```

---

## Walktrap Clustering

Hierarchical clustering that groups vertices visited together during short random walks.

**When to use:**

- Mid-sized graphs where local community structure is important.
- Scenarios where a dendrogram-like hierarchy is desirable.

**Parameters:**

- `network` (nx.Graph): The network to which the clustering is applied.
- `fraction_shortest_edges` (float): Edge filtering fraction. Defaults to `0.5`.

**Returns:**
`csr_matrix`: Sparse cluster-assignment matrix.

```python
clusters_walktrap = risk.cluster_walktrap(
    network=network,
    fraction_shortest_edges=0.25,
)
```

---

## Spinglass Clustering

Simulated annealing approach inspired by statistical mechanics—slower but effective for small graphs where fine-grained clusters matter.

**When to use:**

- Research settings that explore objective functions from statistical physics.
- Small networks where runtime is less critical.

**Parameters:**

- `network` (nx.Graph): The network to which the clustering is applied.
- `fraction_shortest_edges` (float): Edge filtering fraction. Defaults to `0.5`.

```python
clusters_spinglass = risk.cluster_spinglass(
    network=network,
    fraction_shortest_edges=0.25,
)
```

---

## Next Step

[Statistical Methods](5_statistical_methods.md)
