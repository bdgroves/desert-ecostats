# PERMANOVA & NMDS of Simulated Desert Communities
# -------------------------------------------------
# This script simulates desert species abundance data and associated
# environmental variables, then tests for community differences across
# habitat types using vegan::adonis2 (PERMANOVA). Results are exported
# using here::here() for reproducible file paths and an NMDS plot is
# generated to visualize habitat-based patterns.

# Load required packages
library(vegan)
library(ggplot2)
library(here)

# Ensure output directories exist
if (!dir.exists(here("data"))) dir.create(here("data"))
if (!dir.exists(here("plots"))) dir.create(here("plots"))

# -------------------------------------------------
# 1. Simulate community and environmental data
# -------------------------------------------------
set.seed(123)

n_sites <- 30
habitats <- factor(rep(c("Wash", "Slope", "Flat"), each = n_sites / 3))

# Species abundance matrix (sites x species)
community <- data.frame(
  Rattlesnake   = rpois(n_sites, ifelse(habitats == "Slope", 6, 2)),
  WhiptailLizard = rpois(n_sites, ifelse(habitats == "Wash", 5, 2)),
  Gecko          = rpois(n_sites, ifelse(habitats == "Flat", 4, 1)),
  CreosoteBush   = rpois(n_sites, ifelse(habitats == "Flat", 7, 3)),
  ChollaCactus   = rpois(n_sites, ifelse(habitats == "Slope", 5, 2))
)
rownames(community) <- paste0("Site", seq_len(n_sites))

# Environmental data frame
env <- data.frame(
  Site = rownames(community),
  Habitat = habitats,
  Elevation = round(rnorm(n_sites, 500 + as.numeric(habitats) * 20, 20), 1),
  Soil_Moisture = round(rnorm(n_sites, 10 - as.numeric(habitats), 2), 1)
)

# -------------------------------------------------
# 2. PERMANOVA test for habitat differences
# -------------------------------------------------
permanova_res <- adonis2(community ~ Habitat, data = env, method = "bray",
                        permutations = 999)
print(permanova_res)
# Interpretation: A significant p-value (< 0.05) indicates that community
# composition differs among habitats.

# Save PERMANOVA table to CSV
write.csv(as.data.frame(permanova_res),
          here("data", "permanova_results.csv"),
          row.names = FALSE)

# -------------------------------------------------
# 3. NMDS ordination with habitat coloring
# -------------------------------------------------
nmds <- metaMDS(community, distance = "bray", k = 2, trymax = 100)

scores_df <- as.data.frame(scores(nmds, display = "sites"))
scores_df$Habitat <- env$Habitat

nmds_plot <- ggplot(scores_df, aes(x = NMDS1, y = NMDS2, color = Habitat)) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "NMDS of Desert Community Composition",
       color = "Habitat")

# Save NMDS plot as PNG
ggsave(filename = here("plots", "nmds_habitat.png"), plot = nmds_plot,
       width = 6, height = 5, dpi = 300)
