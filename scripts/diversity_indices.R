# Load necessary package
library(vegan)

# Load example data
community <- read.csv("data/example_community_matrix.csv", row.names = 1)

# Calculate indices
richness <- specnumber(community)   # # of species per plot
shannon <- diversity(community, index = "shannon")  # Shannon diversity index
simpson <- diversity(community, index = "simpson")  # Simpson diversity index
evenness <- shannon / log(richness)  # Shannon evenness

# Create results table
results <- data.frame(
  Plot = rownames(community),
  Richness = richness,
  Shannon = shannon,
  Simpson = simpson,
  Evenness = evenness
)

# Print and export results
print(results)
write.csv(results, "plots/diversity_summary.csv", row.names = FALSE)

# Plot rarefaction curve
pdf("plots/rarefaction_curve.pdf")
rarecurve(community, step = 1, col = rainbow(nrow(community)))
dev.off()
