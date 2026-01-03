navbarUI <- function(id, currentPage) {
  ns <- NS(id)  
  
  tags$nav(class = "border-b-4 border-orange-600 w-full h-24 flex items-center justify-between",
           
    # Logo 
    tags$a(class = "flex items-center h-full ml-8",
           tags$img(src = "LogoNav.png", alt = "Logo", class = "h-full w-auto object-contain")
    ),
    
    # Menu links 
    tags$ul(class = "flex space-x-6 mr-8",
      tags$li(
        tags$button(
          class = if (currentPage == "landingPage") "text-orange-600" else "text-gray-500",
          "Home",
          onclick = "Shiny.setInputValue('nav_home', Math.random())"
        )
      ),
      tags$li(
        tags$button(
          class = if (currentPage == "watchlistPage") "text-orange-600" else "text-gray-500",
          "Watchlist",
          onclick = "Shiny.setInputValue('nav_watchlist', Math.random())"
        )
      )
    )
  )
}
