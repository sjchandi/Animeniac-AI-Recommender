navbarUI <- function(id, currentPage) {
  ns <- NS(id)  
  
  tags$nav(
    class = "border-b-4 border-orange-600 w-full h-24 flex items-center justify-between px-8",
    
    # Logo on the left
    tags$a(
      class = "flex items-center h-full",
      tags$img(src = "LogoNav.png", alt = "Logo", class = "h-full w-auto object-contain")
    ),
    
    # Menu links in the center
    tags$div(
      class = "flex-1 flex justify-center",
      tags$ul(
        class = "flex space-x-6",
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
    ),
    
    # Logout button on the right
    tags$div(
      class = "flex items-center",
      buttonUI(
        id = "logoutConfirm",
        text = "Logout",
        size = 5,
      )
    )
  )
}
