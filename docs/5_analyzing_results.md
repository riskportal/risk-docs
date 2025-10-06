# Building and Analyzing Results

The `NetworkGraph` object integrates network data, annotations, and overrepresentation results into a unified structure, supporting clustering, domain-level significance, and downstream visualization.

---

## Create a `NetworkGraph`

**Parameters:**

- `network` (nx.Graph): The network graph containing the nodes and edges to be analyzed.
- `annotation` (dict): The annotation associated with the network, typically derived from biological or functional data.
- `neighborhoods` (dict): The neighborhoods object, containing data from enrichment or depletion analysis.
- `tail` (str, optional): Specifies the tail of the statistical test to use. Options include:
    - `'right'`: For enrichment. _(default)_
    - `'left'`: For depletion.
    - `'both'`: For two-tailed analysis.
- `pval_cutoff` (float, optional): Cutoff value for p-values to determine significance. Range: Any value between 0 and 1. Defaults to 0.01.
- `fdr_cutoff` (float, optional): Cutoff value for FDR-corrected p-values. Range: Any value between 0 and 1. Defaults to 0.9999.
- `impute_depth` (int, optional): Depth for imputing missing values. Defaults to 1.
- `prune_threshold` (float, optional): Threshold for pruning weak edges from the network graph. Range: Any value between 0 and 1. Defaults to 0.0.
- `linkage_criterion` (str, optional): Criterion for clustering. Defaults to 'distance'. Options include:
    - `'distance'`: Clusters are formed based on distance.
    - `'maxclust'`: Clusters are formed based on the maximum number of clusters.
    - `'off'`: Disables clustering; terms remain separate.
- `linkage_method` (str, optional): Method used for hierarchical clustering. Defaults to 'average'. Options include:
    - `'auto'`: Automatically determines the optimal method using the silhouette score.
    - Other options: `'single'`, `'complete'`, `'average'`, `'weighted'`, `'centroid'`, `'median'`, `'ward'`.
- `linkage_metric` (str, optional): Distance metric used for clustering. Defaults to 'yule'. Options include:
    - `'auto'`: Automatically determines the optimal metric using the silhouette score.
    - Other options: `'braycurtis'`, `'canberra'`, `'chebyshev'`, `'cityblock'`, `'correlation'`, `'cosine'`, `'dice'`, `'euclidean'`, `'hamming'`, `'jaccard'`, `'jensenshannon'`, `'kulczynski1'`, `'mahalanobis'`, `'matching'`, `'minkowski'`, `'rogerstanimoto'`, `'russellrao'`, `'seuclidean'`, `'sokalmichener'`, `'sokalsneath'`, `'sqeuclidean'`, `'yule'`.
- `linkage_threshold` (str or float, optional): The cutoff distance for forming flat clusters in hierarchical clustering. Accepts either a numeric threshold or `'auto'` to enable automatic threshold optimization using the silhouette score. Range depends on metric. Defaults to 0.2.
- `min_cluster_size` (int, optional): Minimum size of clusters to be formed. Defaults to 5.
- `max_cluster_size` (int, optional): Maximum size of clusters to be formed. Defaults to 1000.

**Returns:**
`NetworkGraph`: A `NetworkGraph` object representing the processed network, ready for analysis and visualization.

```python
graph = risk.load_graph(
    network=network,
    annotation=annotation,
    neighborhoods=neighborhoods,
    tail="right",
    pval_cutoff=0.01,
    fdr_cutoff=0.9999,
    impute_depth=1,
    prune_threshold=0.0,
    linkage_criterion="distance",
    linkage_method="average",
    linkage_metric="yule",
    linkage_threshold=0.2,
    min_cluster_size=5,
    max_cluster_size=1000
)
```

## Key Attributes

The `NetworkGraph` object exposes several mappings for cluster and node information:

### Domain-Level

- `domain_id_to_node_ids_map`: Maps each domain ID to the list of node IDs belonging to that domain.
- `domain_id_to_node_labels_map`: Maps each domain ID to the list of node labels in that domain for readable visualization.
- `domain_id_to_domain_terms_map`: Maps each domain ID to the list of overrepresented/significant terms associated with that domain.
- `domain_id_to_domain_info_map`: Maps each domain ID to a metadata record (e.g., size, p-value, FDR, summary) about the domain.

### Node-Level

- `node_id_to_node_label_map`: Maps each internal node ID to its display label.
- `node_label_to_node_id_map`: Maps each display label back to its internal node ID.
- `node_label_to_significance_map`: Maps each node label to its significance score from the analysis.
- `node_significance_sums`: Array of aggregate significance values per node, used for sizing, coloring, or ranking.

These attributes enable visualization, labeling, and export functionalities.

---

## Summarize results

Inspect matched members, counts, and significance in a DataFrame.

```python
summary_df = graph.summary.load()
summary_df.head()
```

### Export Summary

Export the processed summary table in common formats for downstream use or sharing.

**Shared Parameters:**

Shared parameters among export methods.

- `filepath` (str): The path where the file will be saved.

```python
graph.summary.to_csv("./data/csv/summary/michaelis_2023.csv")
graph.summary.to_json("./data/json/summary/michaelis_2023.json")
graph.summary.to_txt("./data/txt/summary/michaelis_2023.txt")
```

## Clean domains

Remove a domain (in-place) and retrieve its node labels:

```python
domain_1_labels = graph.pop(1)
```

---

## Next Step

[Visualizing Networks in RISK](6_visualization.md)
