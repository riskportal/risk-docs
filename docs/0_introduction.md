# Introduction to RISK

Regional Inference of Significant Kinships (RISK) is a next-generation tool for biological network annotation and visualization. It integrates community detection algorithms, statistically rigorous overrepresentation analysis, and high-resolution visualization to uncover structured relationships in complex networks.

RISK is designed to:

- Identify biologically coherent modules in large-scale networks
- Perform fast and flexible overrepresentation testing
- Generate publication-ready visualizations
- Scale to networks with hundreds of thousands of edges on standard hardware
- Generalize beyond biology to interdisciplinary networks

## RISK Features

| Category           | Capabilities                                                                                  |
| ------------------ | --------------------------------------------------------------------------------------------- |
| **Clustering**     | Louvain, Leiden, Markov Clustering, Spinglass, Walktrap, Greedy Modularity, Label Propagation |
| **Statistical Tests** | Permutation, Hypergeometric, Chi-squared, Binomial                                         |
| **Network Formats**  | Cytoscape, Cytoscape JSON, GPickle, NetworkX                                                  |
| **Annotation Formats** | JSON, CSV, TSV, Excel, Python dictionary                                                  |
| **Scalability**    | Efficient analysis of networks with 500k+ edges on standard hardware                          |
| **Visualization**  | High-resolution outputs (SVG, PNG, PDF)                                                       |
| **Cross-domain Use** | Demonstrated on physics citation networks (Supplementary Fig. S7)                           |

## Example Applications

- Functional module identification in _S. cerevisiae_ PPI and GI networks
- Chemical–genetic interaction (Chem-GI) mapping to infer compound targets
- Microbial interaction networks to reveal host–pathogen relationships
- Cross-domain application to non-biological networks (e.g., physics citation networks)

## Interactive Examples

[For a complete workflow, see tutorial.html](tutorial.html), which demonstrates all key steps—from loading a network to generating publication-ready figures—in a single notebook. [You can also download the notebook and data as a ZIP](tutorial.zip).

The tutorial applies RISK to the _Saccharomyces cerevisiae_ protein–protein interaction (PPI) network (3,839 nodes, 30,955 edges; Michaelis _et al_., 2023). It illustrates:

- Network clustering and module detection
- Annotation-based overrepresentation analysis
- Advanced visualization and interactive exploration
- Parameter export and reproducibility tools

This notebook complements this documentation—use it for end-to-end examples and contextual guidance.

<a href="https://mybinder.org/v2/gh/riskportal/risk-docs/HEAD?filepath=notebooks/quickstart.ipynb" target="_blank" rel="noopener">You can also launch the Quickstart notebook on Binder</a> for an interactive session without local installation.

## Next Step

[Installation and Setup](1_installation.md)
