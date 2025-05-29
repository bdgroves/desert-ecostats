# ===============================
# Desert EcoStats Teaching Script
# Indicator Species Analysis + Seasonal Animation + Interactive Mapping
# ===============================

# ---- Load Required Packages ----
library(indicspecies)
library(ggplot2)
library(dplyr)
library(gganimate)
library(gifski)
library(leaflet)
library(htmlwidgets)

# ---- Ensure Output Folders Exist ----
if (!dir.exists("plots")) dir.create("plots")
if (!dir.exists("data")) dir.create("data")

# ---- 1. Simulated Community Matrix (Species x Site) ----
set.seed(42)

comm_data <- data.frame(
  DesertWillow   = c(8,7,9,8,9,9,  0,0,0,1,0,0,  1,1,0,0,1,0),
  ChollaCactus   = c(0,0,0,1,0,0,  8,9,7,8,9,7,  1,1,1,0,1,1),
  Burrograss     = c(0,0,0,0,1,0,  0,0,0,1,0,0,  8,7,9,9,8,9),
  Ant            = rep(3, 18),
  KangarooRat    = c(6,6,6,6,5,5,  1,1,0,1,0,0,  2,2,2,2,1,2),
  HornedLizard   = c(0,0,0,0,1,1,  6,5,6,5,6,5,  1,1,0,0,1,1)
)
row.names(comm_data) <- paste0("Site", 1:18)

# ---- 2. Define Habitat Types ----
habitat_type <- c(rep("Sandy Wash", 6), rep("Rocky Slope", 6), rep("Gravel Flat", 6))

# ---- 3. Simulated Site Coordinates ----
site_coords <- data.frame(
  Site = row.names(comm_data),
  Latitude = runif(18, 34.0, 34.5),
  Longitude = runif(18, -115.5, -115.0),
  Habitat = habitat_type
)

# ---- 4. Run Indicator Species Analysis ----
isa_result <- multipatt(comm_data, habitat_type, control = how(nperm = 999))
summary(isa_result)

# ---- 5. Extract Significant Indicators ----
indicators <- isa_result$sign
indicators$Species <- rownames(indicators)
group_cols <- grep("^s\\.", names(indicators), value = TRUE)
indicators$Habitat <- apply(indicators[, group_cols], 1, function(x) {
  colnames(indicators[, group_cols])[which(x == 1)]
})
indicators$Habitat <- gsub("^s\\.", "", indicators$Habitat)
significant <- subset(indicators, p.value <= 0.05)

# ---- 6. Export Results ----
write.csv(significant, "data/significant_indicator_species.csv", row.names = FALSE)

# ---- 7. Plot and Save Bar Chart ----
if (nrow(significant) > 0) {
  p <- ggplot(significant, aes(x = reorder(Species, stat), y = stat, fill = Habitat)) +
    geom_col() +
    coord_flip() +
    labs(
      title = "Significant Indicator Species by Habitat",
      x = "Species",
      y = "Indicator Value (IndVal)",
      fill = "Habitat"
    ) +
    theme_minimal()
  
  ggsave("plots/indicator_species_plot.png", plot = p, width = 8, height = 5)
  print(p)
} else {
  message("⚠️ No significant indicator species found.")
}

# ---- 8. Create Seasonal Data for Animation ----
seasons <- c("Spring", "Summer", "Fall")
site_map_time <- site_coords %>%
  slice(rep(1:n(), each = length(seasons))) %>%
  mutate(Season = rep(seasons, times = nrow(site_coords)))

# Add jitter to simulate seasonal variation
set.seed(123)
site_map_time$Latitude <- site_map_time$Latitude + rnorm(nrow(site_map_time), 0, 0.01)
site_map_time$Longitude <- site_map_time$Longitude + rnorm(nrow(site_map_time), 0, 0.01)

# ---- 9. Animate Site Map by Season ----
anim_plot <- ggplot(site_map_time, aes(x = Longitude, y = Latitude, color = Habitat)) +
  geom_point(size = 4) +
  theme_minimal() +
  labs(
    title = "Site Locations by Season: {closest_state}",
    x = "Longitude", y = "Latitude"
  ) +
  transition_states(Season, transition_length = 2, state_length = 1) +
  ease_aes("cubic-in-out")

animate(anim_plot, width = 600, height = 500, fps = 2,
        renderer = gifski_renderer("plots/site_map_seasonal.gif"))

# ---- 10. Interactive Site Map with Leaflet ----
habitat_pal <- colorFactor(palette = "Set2", domain = site_coords$Habitat)

leaflet_map <- leaflet(site_coords) %>%
  addTiles() %>%
  addCircleMarkers(
    ~Longitude, ~Latitude,
    color = ~habitat_pal(Habitat),
    label = ~paste(Site, "-", Habitat),
    radius = 6,
    stroke = TRUE, fillOpacity = 0.8
  ) %>%
  addLegend("bottomright", pal = habitat_pal, values = ~Habitat,
            title = "Habitat Type", opacity = 1)

leaflet_map
htmlwidgets::saveWidget(leaflet_map, "plots/site_map_leaflet.html", selfcontained = TRUE)
