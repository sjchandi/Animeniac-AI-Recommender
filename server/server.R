server <- function(input, output, session) {
  
  # DB connection
  con <- dbConnect(
    MariaDB(),
    dbname = Sys.getenv("DB_NAME"),
    host = Sys.getenv("DB_HOST"),
    port = as.integer(Sys.getenv("DB_PORT")),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PASS")
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
  
  #Anime Data
  anime_data <- reactiveVal(DBI::dbGetQuery(con, "SELECT * FROM anime_watchlist"))
  
  # Open Add modal
  observeEvent(input$addButton, {
    showModal(crudModalUI("addModal"))
  })
  
  # Initialize CRUD module
  crudModalAddServer("addModal", con, anime_data = anime_data)
  
  # Track the current record being edited
  current_edit <- reactiveVal(NULL)
  
  # Initialize Edit modal module once
  crudModalEditServer("editModal", con, record_id = current_edit, anime_data = anime_data)
  
  # Initialize table module
  tableServer("anime_table", con, current_edit, anime_data = anime_data)
  
  # Render anime cards
  animeCardsServer("anime")
  
  #Response Generation
  observeEvent(input$generate_recommendation, {
    
    watchlist_df <- dbGetQuery(con, "SELECT name FROM anime_watchlist")
    
    if (nrow(watchlist_df) == 0) {
      showNotification(
        "The watchlist table is empty. Add some anime first.",
        type = "warning"
      )
      return()  # Stop further processing
    }
    
    anime_watchlist <- paste(watchlist_df$title, collapse = ", ")
    
    
    if (nrow(watchlist_df) == 0) {
      showNotification(
        "Your watchlist is empty. Add anime first.",
        type = "warning"
      )
      return()
    }
    
    anime_watchlist <- paste(watchlist_df$title, collapse = ", ")
    
    # Loading modal
    showModal(
      modalDialog(
        tags$div(
          "Recommending anime...",
          class = "text-center text-orange-600 font-semibold"
        ),
        footer = NULL,
        easyClose = FALSE
      )
    )
    
    
    tryCatch({
      ai_text <- aiGeminiResponse(input$anime_watchlist)
    
      showModal(
        modalDialog(

          title = NULL,
          
          # Title
          tags$h2(
            class = "text-3xl font-semibold text-gray-800 text-center mb-1",
            "🎌 Anime Recommendations"
          ),
          tags$pre(
            style = "white-space: pre-wrap; font-size: 16px;",
            ai_text
          ),
          footer = modalButton("Close"),
          easyClose = TRUE
        )
      )
      
    }, error = function(e) {
      removeModal()
      showNotification(
        paste("API Error:", e$message),
        type = "error"
      )
    })
  })
  
  
  # Disconnect DB on session end
  session$onSessionEnded(function() { DBI::dbDisconnect(con) })
}
