# Schizophrenia & Bipolar I disorder Manifold
This is the official code for Revealing Differential Psychotic Symptom patterns in Schizophrenia and Bipolar I Disorder by Manifold Learning and Network Analysis (Kim et al., 2024).

## Description

This repository contains Python and R scripts for analyzing psychotic symptoms in schizophrenia and bipolar I disorder using manifold learning and network analysis. The analyses include visualization of symptom distributions, support vector machine (SVM) decision boundaries, and network centrality measures.

## Contents

- `manifold_analysis.py`: Python script for manifold learning and visualization of psychotic symptoms.
- `network_analysis.R`: R script for network analysis of psychotic symptoms.

## Requirements

### Python

- `numpy`
- `pandas`
- `umap-learn`
- `scikit-learn`
- `matplotlib`

### R

- `networktools`
- `IsingFit`
- `qgraph`
- `igraph`
- `bootnet`
- `NetworkComparisonTest`
- `haven`
- `centiserve`
- `cowplot`
- `dplyr`
- `patchwork`

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your_username/scz_bip_manifold.git
   cd scz_bip_manifold
   ```

2. **Install Python dependencies**:

   ```bash
   pip install numpy pandas umap-learn scikit-learn matplotlib
   ```

3. **Install R dependencies**:

   ```R
   install.packages(c("networktools", "IsingFit", "qgraph", "igraph", "bootnet", "NetworkComparisonTest", "haven", "centiserve", "cowplot", "dplyr", "patchwork"))
   ```

## Usage

### Python Script

1. Run the manifold analysis:

   ```bash
   python manifold_analysis.py
   ```

2. This script will normalize and embed the data using UMAP, and visualize symptom distributions and SVM decision boundaries. Results will be saved in the `results/` directory as svg format.

### R script

1. Run the network analysis:
   Open `network_analysis.R` in an R environment, and execute the script.
2. This script will perform network analysis on the schizophrenia and bipolar I disorder data, calculating and plotting centrality measures (Katz, betweenness, closeness, strength). Results will be saeved in the `results/` directory.

## Citation

If you use this code, please cite the following paper:

Kim, et al. (2024). "Revealing Differential Psychotic Symptom Patterns in Schizophrenia and Bipolar I Disorder by Manifold Learning and Network Analysis."
