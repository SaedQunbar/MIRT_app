# 0.0 INFORMATION ---------------------------------------------------------
#
# PROGRAM:			Ackerman 2016 Psychometric Society Presidential Address
# PURPOSE:      Creating open source graphics to be included in TA's
#               Pscyhometric Society Paper.
#
# PROGRAMMER: 	Saed Qunbar
#
# 0.1 Packages ------------------------------------------------------------


# package check and plotly devtools ---------------------------------------

# install.packages("plotly")
# install.packages("shiny")

# For development versions
# install.packages("miniUI") # needed this first
# if (!require("devtools")) install.packages("devtools")
# devtools::install_github("ropensci/plotly")

# packageVersion('plotly') # checking version


library(plotly)
library(shiny)


# Define UI for application
ui <- fluidPage(# Application title
  titlePanel("MIRT Graphics"),

  # Sidebar with a sliders for item parameters
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "d",
        "d:",
        min = -2,
        max = 2,
        value = 0,
        step = .01
      ),

      sliderInput(
        "a1",
        "a1:",
        min = 0,
        max = 2,
        value = .5,
        step = .01
      ),

      sliderInput(
        "a2",
        "a2:",
        min = 0,
        max = 2,
        value = .5,
        step = .01
      )
    ),

    # Show a plotly plot of the generated distribution
    mainPanel(tabsetPanel(
      type = "tabs",
      tabPanel(
        "2-Trait MIRT Model",
        plotlyOutput("itemplot", height = 600, width = 1000)
      ),
      tabPanel(
        "Contour",
        plotlyOutput("contourplot", height = 600, width = 1000)
      )
    ))
  ))

# Define server logic
server <- function(input, output) {
  output$itemplot <- renderPlotly({
    # input parameters
    d <- seq(-2, 2, .01)
    a1 <- seq(0, 2, .01)
    a2 <- seq(0, 2, .01)

    t1 <- seq(-3, 3, .1)
    t2 <- seq(-3, 3, .1)
    p <- matrix(nrow = length(t1), ncol = length(t2))

    # creating the matrix of values for the z axis using the slider inputs
    # through vectorization
    for (i in 1:length(t2)) {
      for (j in 1:length(t1)) {
        p[i, j] <-
          1.0 / (1.0 + exp(-1.7 * (
            input$a1 * t1[j] + input$a2 * t2[i] + input$d
          )))
      }
    }

    df <- list(t1, t2, p)

    names(df) <- c("t1", "t2", "p")

    p <-
      plot_ly(
        x = df$t1,
        y = df$t2,
        z = df$p,
        type = "surface"
      ) %>%
      layout(scene = list(
        xaxis = list(title = "Theta 1"),
        yaxis = list(title = "Theta 2"),
        zaxis = list(title = "P")
      ),
      dragmode = "turntable")
    p
  })
  output$contourplot <- renderPlotly({
    # input parameters
    d <- seq(-2, 2, .01)
    a1 <- seq(0, 2, .01)
    a2 <- seq(0, 2, .01)

    t1 <- seq(-3, 3, .1)
    t2 <- seq(-3, 3, .1)
    p <- matrix(nrow = length(t1), ncol = length(t2))

    # creating the matrix of values for the z axis using the slider inputs
    # through vectorization
    for (i in 1:length(t2)) {
      for (j in 1:length(t1)) {
        p[i, j] <-
          1.0 / (1.0 + exp(-1.7 * (
            input$a1 * t1[j] + input$a2 * t2[i] + input$d
          )))
      }
    }

    df <- list(t1, t2, p)

    names(df) <- c("t1", "t2", "p")

    p <- plot_ly(
      x = df$t1,
      y = df$t2,
      z = df$p,
      type = "contour"
    ) %>%
      add_annotations(
        x = (input$a1 * ((-input$d / sqrt(input$a1 ^ 2 + input$a2 ^ 2)) + (sqrt(input$a1 ^ 2 + input$a2 ^ 2))) / sqrt(input$a1^2 + input$a2^2)),
        y = (input$a2 * ((-input$d / sqrt(input$a1 ^ 2 + input$a2 ^ 2)) + (sqrt(input$a1 ^ 2 + input$a2 ^ 2))) / sqrt(input$a1^2 + input$a2^2)),
        text = "",
        showarrow = TRUE,
        ax = (-input$a1 * input$d / (input$a1 ^ 2 + input$a2 ^ 2)),
        ay = (-input$a2 * input$d / (input$a1 ^ 2 + input$a2 ^ 2)),
        axref = "x",
        ayref = "y"
      )
    p
  })
}

# Run the application
shinyApp(ui = ui, server = server)
