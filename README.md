------------------------------------------------------------------------

``` markdown
# 🏜️ Desert EcoStats Toolkit

A collection of reproducible R scripts for analyzing desert ecological communities. Designed to process community matrix data (species × plots) and explore biodiversity patterns, species associations, and community structure.

---

## 🔁 Workflow Overview

```plaintext
Raw Community Matrix
        │
        ▼
[1] Diversity Indices
    - Richness, Shannon, Simpson
    - Evenness, rarefaction

        ▼
[2] Ordination (NMDS)
    - Visualize community structure
    - Identify compositional patterns

        ▼
[3] Co-occurrence Analysis
    - Detect species-level associations
    - Reveal positive/negative pairings
```

------------------------------------------------------------------------

## 📜 Scripts & What They Do

### `diversity_summary.R`

🧮 Calculates basic biodiversity metrics per plot. - **Richness**: \# of species - **Shannon & Simpson**: Diversity indices - **Evenness**: How evenly species are distributed - **Rarefaction Curve**: Sampling effort vs. richness

📤 Outputs: - `diversity_summary.csv` - `rarefaction_curve.pdf`

------------------------------------------------------------------------

### `ordination_nmds.R`

📊 Performs **Non-metric Multidimensional Scaling (NMDS)** using Bray-Curtis dissimilarity. - Reduces high-dimensional data into 2D - Useful for identifying patterns in species composition

📤 Outputs: - `nmds_plot.pdf` (base R) - `nmds_plot_ggplot.pdf` (optional: cleaner ggplot version)

------------------------------------------------------------------------

### `cooccurrence_analysis.R`

🔗 Uses the `cooccur` package to analyze non-random species co-occurrences. - Converts data to presence/absence - Identifies significant positive or negative pairings

📤 Outputs: - `cooccurrence_summary.txt` (summary of interactions) - `all_species_pairs.csv` (all pairwise results) - `cooccurrence_plot.pdf` (heatmap visualization)

### `map_california_counties.R`

🗺️ Generates a simple map of California counties **with county labels** using the `maps` package.

📤 Outputs: - `california_counties_map.pdf`

### `permanova_nmds.R`

🔄 Simulates desert community data, runs a PERMANOVA test across habitat
types, and visualizes results with an NMDS plot colored by habitat.

📤 Outputs: - `permanova_results.csv` - `nmds_habitat.png`
### `desert_constrained_ordination_app.R`

🖥️ Interactive Shiny app to perform constrained ordination (RDA or CCA) on simulated desert data. Choose the method, run the analysis, and view the ordination plot plus printed summary.



------------------------------------------------------------------------

## 📂 Directory Structure

``` plaintext
desert-ecostats/
├── data/
│   ├── example_community_matrix.csv
│   ├── desert_community_matrix.csv
│   └── desert_environmental_data.csv
├── plots/
│   ├── diversity_summary.csv
│   ├── rarefaction_curve.pdf
│   ├── nmds_plot.pdf
│   ├── cooccurrence_plot.pdf
│   └── ...
├── scripts/
│   ├── diversity_summary.R
│   ├── ordination_nmds.R
│   ├── cooccurrence_analysis.R
│   ├── map_california_counties.R
│   ├── permanova_nmds.R
│   └── desert_constrained_ordination_app.R
└── README.md  ← You are here
```

------------------------------------------------------------------------

## 🔧 Requirements

-   R ≥ 4.2
-   Packages: `vegan`, `cooccur`, `ggplot2`, `shiny`, `maps`, `here`

``` r
install.packages(c("vegan", "cooccur", "ggplot2", "shiny", "maps", "here"))
```

------------------------------------------------------------------------

## 🚧 Coming Soon

-   Constrained ordination (CCA/RDA)
-   Indicator species analysis
-   Integration of habitat metadata \`\`\`
