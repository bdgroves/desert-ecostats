# ==========================================================================
# Map of California Counties
# ==========================================================================
# This script uses the maps and ggplot2 packages to generate a simple map
# of California counties and saves it to the plots directory.
# ==========================================================================

# Load required packages
library(ggplot2)
library(maps)

# --------------------------------------------------------------------------
# Fetch county boundaries from the 'maps' package and filter to California
# --------------------------------------------------------------------------
counties <- map_data("county")
ca_counties <- subset(counties, region == "california")

# --------------------------------------------------------------------------
# Determine approximate label positions for each county
# --------------------------------------------------------------------------
label_positions <- aggregate(cbind(long, lat) ~ subregion,
                             data = ca_counties, FUN = mean)

# --------------------------------------------------------------------------
# Plot and save the map
# --------------------------------------------------------------------------

p <- ggplot(ca_counties, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "gray80", color = "white") +
  geom_text(data = label_positions,
            aes(x = long, y = lat, label = subregion),
            size = 2, color = "black", check_overlap = TRUE) +
  coord_fixed(1.3) +
  theme_void() +
  labs(title = "California Counties")

# Create plots directory if it does not exist
if (!dir.exists("plots")) dir.create("plots")

# Save the map as PDF
ggsave(filename = "plots/california_counties_map.pdf", plot = p,
       width = 7, height = 8)
