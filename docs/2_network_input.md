# Loading Networks into RISK

Networks form the foundation of any RISK analysis, representing nodes (e.g., genes, proteins, papers) and the edges, or relationships, connecting them.

RISK provides flexible loading functions compatible with multiple formats—including Cytoscape session files, Cytoscape JSON exports, GPickle files, and in-memory NetworkX graphs. These loaders standardize input into NetworkX graph objects ready for downstream analysis, with options for preprocessing such as spherical projection, surface depth adjustment, and node filtering.

---

## Supported Input Formats

| Format     | Method                     | Description                                                                                   |
| ---------- | -------------------------- | --------------------------------------------------------------------------------------------- |
| `.cys`     | `load_network_cytoscape()` | Load from Cytoscape session files; supports source/target labels and optional view selection. |
| `.cyjs`    | `load_network_cyjs()`      | Import Cytoscape JSON format; specify source and target labels for nodes and edges.           |
| `.gpickle` | `load_network_gpickle()`   | Reload serialized NetworkX graphs; preserves full network structure.                          |
| `NetworkX` | `load_network_networkx()`  | Convert an existing NetworkX graph object into a RISK-compatible format.                      |

---

## Cytoscape `.cys` Files

Load Cytoscape session files exported from the desktop app.

**Parameters:**

- `filepath` (str): Path to the Cytoscape file.
- `source_label` (str, optional): Source node label. Defaults to "source".
- `target_label` (str, optional): Target node label. Defaults to "target".
- `view_name` (str, optional): Specific view name to load. Defaults to "".
- `compute_sphere` (bool, optional): Whether to map nodes from a 2D plane onto a 3D spherical surface using a spherical projection. Defaults to True.
- `surface_depth` (float, optional): Adjusts the depth of nodes relative to the spherical surface, enhancing visualization of clustering. Defaults to 0.0.
- `min_edges_per_node` (int, optional): Minimum number of edges per node. Values >0 prune nodes with fewer edges. Defaults to 0.

**Returns:**
`nx.Graph`: The loaded and processed network as a NetworkX graph.

```python
network = risk.load_network_cytoscape(
    filepath="./data/cytoscape/michaelis_2023.cys",
    source_label="source",
    target_label="target",
    view_name="",
    compute_sphere=True,
    surface_depth=0.0,
    min_edges_per_node=0,
)
```

---

## Cytoscape JSON (`.cyjs`) Files

Load JSON exports from Cytoscape Web or JavaScript pipelines.

**Parameters:**

- `filepath` (str): Path to the Cytoscape JSON file.
- `source_label` (str, optional): Source node label. Defaults to "source".
- `target_label` (str, optional): Target node label. Defaults to "target".
- `compute_sphere` (bool, optional): Whether to map nodes from a 2D plane onto a 3D spherical surface using a spherical projection. Defaults to True.
- `surface_depth` (float, optional): Adjusts the depth of nodes relative to the spherical surface, enhancing visualization of clustering. Defaults to 0.0.
- `min_edges_per_node` (int, optional): Minimum number of edges per node. Values >0 prune nodes with fewer edges. Defaults to 0.

**Returns:**
`nx.Graph`: The loaded and processed network as a NetworkX graph.

```python
network = risk.load_network_cyjs(
    filepath="./data/cyjs/michaelis_2023.cyjs",
    source_label="source",
    target_label="target",
    compute_sphere=True,
    surface_depth=0.1,
    min_edges_per_node=1,
)
```

---

## GPickle (`.gpickle`) Files

Fast, Python-native serialization of NetworkX graphs preserving all attributes. Recommended for reproducibility and performance.

**Parameters:**

- `filepath` (str): Path to the GPickle file.
- `compute_sphere` (bool, optional): Whether to map nodes from a 2D plane onto a 3D spherical surface using a spherical projection. Defaults to True.
- `surface_depth` (float, optional): Adjusts the depth of nodes relative to the spherical surface, enhancing visualization of clustering. Defaults to 0.0.
- `min_edges_per_node` (int, optional): Minimum number of edges per node. Values >0 prune nodes with fewer edges. Defaults to 0.

**Returns:**
`nx.Graph`: The loaded and processed network as a NetworkX graph.

```python
network = risk.load_network_gpickle(
    filepath="./data/gpickle/michaelis_2023.gpickle",
    compute_sphere=True,
    surface_depth=0.1,
    min_edges_per_node=1,
)
```

---

## NetworkX Graphs

Load from an in-memory `networkx.Graph`. Integrates seamlessly when the graph is already loaded.

### Node Attributes

RISK expects basic spatial and labeling information to be present on each node.

- **Node position** must be provided either as separate numeric attributes `x` and `y`, or as a single `pos = (x, y)` tuple. These are used for layout initialization and visualization.
- **Node labels** used for annotation mapping, enrichment, and reporting are taken from the node attribute `label` if present. If `label` is not provided, the node identifier itself is used as the label.

**Parameters:**

- `network` (nx.Graph): A NetworkX graph object.
- `compute_sphere` (bool, optional): Whether to map nodes from a 2D plane onto a 3D spherical surface using a spherical projection. Defaults to True.
- `surface_depth` (float, optional): Adjusts the depth of nodes relative to the spherical surface, enhancing visualization of clustering. Defaults to 0.0.
- `min_edges_per_node` (int, optional): Minimum number of edges per node. Values >0 prune nodes with fewer edges. Defaults to 0.

**Returns:**
`nx.Graph`: The loaded and processed network as a NetworkX graph.

```python
network = risk.load_network_networkx(
    network=network,
    compute_sphere=True,
    surface_depth=0.1,
    min_edges_per_node=1,
)
```

---

## Next Step

[Loading Annotations into RISK](3_annotation_input.md)
