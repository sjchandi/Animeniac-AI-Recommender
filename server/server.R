server <- function(input, output, session) {
  
  # DB connection
  con <- dbConnect(
    MySQL(),
    dbname = "animeniac",
    host = "localhost",
    port = 3306,
    user = "root",
    password = ""
  )
  
  # Track current page: NULL = loading
  currentPage <- reactiveVal(NULL)
  
  # Check browser storage after session is ready
  session$onFlushed(function() {
    runjs("
      if (localStorage.getItem('loggedIn') === 'true') {
        Shiny.setInputValue('loginFromStorage', true, {priority: 'event'});
      } else {
        Shiny.setInputValue('loginFromStorage', false, {priority: 'event'});
      }
    ")
  })
  
  # Set page after checking login
  observeEvent(input$loginFromStorage, {
    if (input$loginFromStorage) {
      currentPage("landingPage")
    } else {
      currentPage("loginPage")
    }
  })
  
  # Handle login
  observeEvent(input[["login-loginBtn"]], {   
    username <- input[["login-username"]]     
    password <- input[["login-password"]]     
    
    if (username == "admin" && password == "1234") {
      currentPage("landingPage")  
      runjs("localStorage.setItem('loggedIn', 'true');")
    } else {
      showNotification("Invalid username or password", type = "error")
    }
  })
  
  # Handle logout
  observeEvent(input$logoutBtn, {
    runjs("localStorage.removeItem('loggedIn');")
    currentPage("loginPage")
  })
  
  # Render UI (single renderUI)
  output$pageUI <- renderUI({
    if (is.null(currentPage())) {
      # Loading screen to prevent flash
      tags$div(style = "height:100vh; display:flex; justify-content:center; align-items:center; color:#f97316;",
               "Loading...")
    } else if (currentPage() == "loginPage") {
      loginPage("login")
    } else if (currentPage() == "landingPage") {
      landingPageUI
    } else if (currentPage() == "watchlistPage") {
      watchlistPageUI
    }
  })
  
  # Navigation after login
  observeEvent(input$nav_home, { currentPage("landingPage") })
  observeEvent(input$nav_watchlist, { currentPage("watchlistPage") })
  
  # Open Add modal
  observeEvent(input$addButton, {
    showModal(crudModalUI("addModal"))
  })
  
  # Initialize CRUD module
  crudModalServer("addModal", con)
  
  # Initialize table module
  tableServer("anime_table", con)
  
  # Render anime cards
  animeCardsServer("anime")
  
  # Disconnect DB on session end
  session$onSessionEnded(function() { DBI::dbDisconnect(con) })
}
