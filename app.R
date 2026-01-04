library(shiny)
library(shinyjs)
library(DBI)
library(RPostgres)
library(glue)
library(DT)
library(reactable)
library(httr2)

source("modules/navbarUI.R")
source("modules/animeModalUI.R")
source("modules/bannerUI.R")
source("modules/buttonUI.R")
source("modules/animeCardsUI.R")
source("modules/crudModalUI.R")
source("modules/crudModalEditUI.R")
source("modules/tableUI.R")

source("ui/loginPage.R")
source("ui/landingPage.R")
source("ui/watchlistPage.R")

source("server/animeCardsServer.R")
source("server/navbarServer.R")   
source("server/server.R")   
source("server/api_kitsu.R") 
source("server/crudModalAddServer.R") 
source("server/tableServer.R") 
source("server/crudModalEditServer.R")
source("server/api_Gemini.R")

ui <- fluidPage(
  useShinyjs(),

# Head with Tailwind + Flowbite CDN
tags$head(
  tags$script(src = "https://cdn.tailwindcss.com"),
  tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/flowbite@4.0.1/dist/flowbite.min.css"),
  tags$script(src = "https://cdn.jsdelivr.net/npm/flowbite@4.0.1/dist/flowbite.min.js"),
  tags$style(HTML("
      body, .container-fluid, .shiny-html-output {
        margin: 0;
        padding: 0;
      }
    "))
),

  uiOutput("pageUI")
)

# Run app
shinyApp(ui = ui, server = server)

