library(shiny)

source("ui/landingPage.R")
source("modules/navbarUI.R")
source("server/server.R")   
source("server/api_kitsu.R") 


shinyApp(ui = landingPageUI, server = server)
