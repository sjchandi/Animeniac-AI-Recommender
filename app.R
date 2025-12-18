library(shiny)
library(shinyjs)

source("modules/navbarUI.R")
source("modules/animeModalUI.R")
source("modules/bannerUI.R")
source("modules/buttonUI.R")
source("ui/landingPage.R")
source("server/server.R")   
source("server/api_kitsu.R") 

# Run the app
shinyApp(ui = landingPageUI, server = animeCards)
