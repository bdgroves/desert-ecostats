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
[3] PERMANOVA
    - Test community differences by habitat
    - NMDS colored by habitat type

        ▼
[4] Co-occurrence Analysis
    - Detect species-level associations
    - Reveal positive/negative pairings

        ▼
[5] Indicator Species Analysis
    - Identify habitat-diagnostic species
    - Seasonal animation + interactive map

        ▼
[6] Constrained Ordination (RDA/CCA)
    - Link community composition to environment
    - Interactive Shiny app
```

---

## 📜 Scripts & What They Do

### `diversity_indices.R`

🧮 Calculates basic biodiversity metrics per plot.

- **Richness**: # of species per plot
- **Shannon & Simpson**: Diversity indices
- **Evenness**: How evenly species are distributed
- **Rarefaction Curve**: Sampling effort vs. richness

📤 Outputs: `plots/diversity_summary.csv`, `plots/rarefaction_curve.pdf`

---

### `ordination_analysis.R`

📊 Performs **Non-metric Multidimensional Scaling (NMDS)** using Bray-Curtis dissimilarity.

- Reduces high-dimensional community data into 2D
- Useful for identifying patterns in species composition
- Includes both base R and ggplot2 versions

📤 Outputs: `plots/nmds_plot.pdf`, `plots/nmds_plot_ggplot.pdf`

---

### `permanova_nmds.R`

🔄 Simulates desert community data, runs a **PERMANOVA** test across habitat types, and visualizes results with an NMDS plot colored by habitat.

📤 Outputs: `plots/permanova_results.csv`, `plots/nmds_habitat.png`

---

### `cooccurrence_analysis.R`

🔗 Uses the `cooccur` package to analyze non-random species co-occurrences.

- Converts abundance data to presence/absence
- Identifies significant positive or negative species pairings

📤 Outputs: `plots/cooccurrence_summary.txt`, `plots/all_species_pairs.csv`, `plots/cooccurrence_plot.pdf`

---

### `indicator_species_analysis_desert.R`

🌵 Runs **Indicator Species Analysis** (IndVal via `indicspecies`) across habitat types.

- Identifies which species are diagnostic for Sandy Wash, Rocky Slope, and Gravel Flat habitats
- Generates a seasonal site animation (GIF) using `gganimate`
- Produces an interactive Leaflet site map

📤 Outputs: `plots/indicator_species_plot.png`, `plots/site_map_seasonal.gif`, `plots/site_map_leaflet.html`

---

### `map_california_counties.R`

🗺️ Generates a map of California counties with labels using the `maps` package.

📤 Outputs: `plots/california_counties_map.pdf`

---

### `desert_constrained_ordination_app.R`

🖥️ Interactive **Shiny app** for constrained ordination (RDA or CCA) on simulated desert data.

- Choose method (RDA or CCA), run analysis, view ordination plot and summary
- Uses `here` for portable file paths

📤 Outputs: Interactive Shiny app (no saved files)

---

## 📂 Directory Structure

```plaintext
desert-ecostats/
├── data/
│   ├── example_community_matrix.csv   ← input for most R scripts
│   ├── desert_community_matrix.csv    ← input for Shiny app
│   └── desert_environmental_data.csv  ← input for Shiny app
├── notebooks/
│   ├── Death_Valley_Ecosystems.ipynb
│   ├── DV_Python_Study.ipynb
│   ├── Bdgroves_xarray.ipynb
│   └── geospatial_xarray.ipynb
├── plots/                             ← generated outputs (not tracked in git)
│   └── ...
├── scripts/
│   ├── diversity_indices.R
│   ├── ordination_analysis.R
│   ├── permanova_nmds.R
│   ├── cooccurrence_analysis.R
│   ├── indicator_species_analysis_desert.R
│   ├── map_california_counties.R
│   └── desert_constrained_ordination_app.R
├── desert-ecostats.Rproj
└── README.md
```

---

## 🔧 Requirements

- R ≥ 4.2
- Packages: `vegan`, `cooccur`, `indicspecies`, `ggplot2`, `gganimate`, `gifski`, `leaflet`, `htmlwidgets`, `shiny`, `maps`, `here`, `dplyr`

```r
install.packages(c(
  "vegan", "cooccur", "indicspecies", "ggplot2",
  "gganimate", "gifski", "leaflet", "htmlwidgets",
  "shiny", "maps", "here", "dplyr"
))
```

- Python ≥ 3.9 (for notebooks): `xarray`, `numpy`, `matplotlib`, `pandas`

---

## 🚧 Coming Soon

- Trait-based diversity analysis
- Species accumulation curves across habitat gradients
- Integration with GBIF occurrence data
