# Load libraries
library(vegan)
library(ggplot2)

# Load community data
community <- read.csv("data/example_community_matrix.csv", row.names = 1)

# Run NMDS with Bray-Curtis
nmds <- metaMDS(community, distance = "bray", k = 2, trymax = 100)

# Check stress value (should be < 0.2 for good ordination)
print(paste("NMDS Stress:", nmds$stress))

# Plot the ordination
pdf("plots/nmds_plot.pdf")
ordiplot(nmds, type = "text", main = "NMDS Ordination of Desert Plots")
dev.off()

# Optional: ggplot version (cleaner)
site.scores <- as.data.frame(scores(nmds, display = "sites"))
site.scores$Plot <- rownames(site.scores)

# Create the NMDS plot object
nmds_plot <- ggplot(site.scores, aes(x = NMDS1, y = NMDS2, label = Plot)) +
  geom_point(color = "darkgreen", size = 4) +
  geom_text(vjust = -1, size = 4) +
  theme_minimal() +
  labs(title = "NMDS Ordination of Desert Community Plots")

# Display it (optional)
print(nmds_plot)

# Save the plot
ggsave("plots/nmds_plot_ggplot.pdf", plot = nmds_plot, width = 7, height = 7)
