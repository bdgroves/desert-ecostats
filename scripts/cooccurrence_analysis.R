# =============================================================================
# Co-occurrence Analysis of Desert Community Matrix
# =============================================================================
# This script loads a community matrix, converts it to presence/absence,
# runs a species co-occurrence analysis, summarizes non-random associations,
# and outputs a report and a heatmap plot.
# =============================================================================

# Load required packages
library(cooccur)  # For species co-occurrence analysis
library(vegan)    # For matrix handling and conversion

# -----------------------------------------------------------------------------
# Load and prepare data
# -----------------------------------------------------------------------------

# Load the community matrix (species x sites)
community <- read.csv("data/example_community_matrix.csv", row.names = 1)

# Convert abundance matrix to presence/absence (required for cooccur)
pa_matrix <- decostand(community, method = "pa")

# -----------------------------------------------------------------------------
# Run co-occurrence analysis
# -----------------------------------------------------------------------------

# Perform probabilistic co-occurrence analysis on binary matrix
cooccurrence_result <- cooccur(
  mat = pa_matrix,
  type = "spp_site",       # species x sites format
  thresh = TRUE,           # remove pairs with expected co-occurrence < 1
  spp_names = TRUE         # retain species names in output
)

# -----------------------------------------------------------------------------
# Output and reporting
# -----------------------------------------------------------------------------

# Console output: summary and significant results only
summary(cooccurrence_result)          # Co-occurrence statistics summary
print(cooccurrence_result)           # Significant species pair interactions

# Save summary to text file
sink("plots/cooccurrence_summary.txt")
summary(cooccurrence_result)
print(cooccurrence_result)
sink()

# Extract the results slot manually (raw pairwise stats)
all_pairs <- cooccurrence_result$results

# Save all pairs to CSV
write.csv(all_pairs, "plots/all_species_pairs.csv", row.names = FALSE)


# -----------------------------------------------------------------------------
# Plotting
# -----------------------------------------------------------------------------

# Save co-occurrence heatmap to PDF
pdf("plots/cooccurrence_plot.pdf")
plot(cooccurrence_result)
dev.off()

# =============================================================================
# End of Script
# =============================================================================
