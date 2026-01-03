# Server
navbarServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    currentPage <- reactiveVal("landingPage")
    
    # Dynamic menu buttons with highlight
    output$menuUI <- renderUI({
      ns <- session$ns
      tags$ul(class = "flex space-x-6 mr-8",
              tags$li(
                actionButton(ns("nav_home"), "Home",
                             class = if (currentPage() == "landingPage") "text-orange-600" else "text-gray-500"
                )
              ),
              tags$li(
                actionButton(ns("nav_watchlist"), "Watchlist",
                             class = if (currentPage() == "watchlistPage") "text-orange-600" else "text-gray-500"
                )
              )
      )
    })
    
    # Dynamic page content
    output$pageUI <- renderUI({
      if (currentPage() == "landingPage") {
        landingPageUI()
      } else {
        watchlistPageUI()
      }
    })
    
    # Navigation logic
    observeEvent(input$nav_home, { currentPage("landingPage") })
    observeEvent(input$nav_watchlist, { currentPage("watchlistPage") })
  })
}
