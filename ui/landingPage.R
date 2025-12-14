library(shiny)

source("modules/navbarUI.R")
source("server/server.R")

landingPageUI = fluidPage(
  
  # Tailwind CDN
  tags$head(
    tags$script(src = "https://cdn.tailwindcss.com"),
    
    #remove default margin of fluid page
    tags$style(HTML("
      body, .container-fluid, .shiny-html-output {
        margin: 0;
        padding: 0;
      }
    "))
    
  ),
  
  #Navbar component
  navbarUI("mainNavbar", currentPage = "landingPage"),
  
  #Landing Banner Img
  tags$img(
    src = "BannerLanding.png",  
    class = "w-full h-auto object-cover" 
  ),
  
  #API Fetching of Anime
  tags$div(class = "overflow-x-auto whitespace-nowrap",
    uiOutput("animeCards")
  )

)
  
