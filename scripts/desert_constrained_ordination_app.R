# Desert Constrained Ordination Shiny App
# ---------------------------------------
# Uses simulated community and environmental data to run
# RDA or CCA based on user choice.

library(shiny)
library(vegan)
library(ggplot2)

# Load simulated data
comm <- read.csv("data/desert_community_matrix.csv", row.names = 1)
env  <- read.csv("data/desert_environmental_data.csv", row.names = 1)
# Ensure factors are treated correctly
env$Habitat <- factor(env$Habitat)

ui <- fluidPage(
  titlePanel("Desert Constrained Ordination"),
  sidebarLayout(
    sidebarPanel(
      selectInput("method", "Method", choices = c("RDA", "CCA")),
      actionButton("run", "Run Analysis")
    ),
    mainPanel(
      plotOutput("ordPlot"),
      verbatimTextOutput("ordSummary")
    )
  )
)

server <- function(input, output) {
  ord <- eventReactive(input$run, {
    if (input$method == "RDA") {
      rda(comm ~ Elevation + Soil_Moisture + Habitat, data = env)
    } else {
      cca(comm ~ Elevation + Soil_Moisture + Habitat, data = env)
    }
  })

  output$ordPlot <- renderPlot({
    req(ord())
    plot(ord(), display = c("sites", "species"),
         main = paste(input$method, "Ordination"))
  })

  output$ordSummary <- renderPrint({
    req(ord())
    summary(ord())
  })
}

shinyApp(ui, server)
