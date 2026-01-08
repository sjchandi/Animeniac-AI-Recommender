server <- function(input, output, session) {
  
  # DB connection
  con <- dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("DB_NAME"),
    host = Sys.getenv("DB_HOST"),
    port = as.integer(Sys.getenv("DB_PORT")),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PASS")
  )
  
  dbExecute(con, "
  CREATE TABLE IF NOT EXISTS anime_watchlist (
      id SERIAL PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      rating INT,
      genre VARCHAR(100),
      finished BOOLEAN DEFAULT FALSE
  );
  ")
  
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
    removeModal()
    runjs("localStorage.removeItem('loggedIn');")
    currentPage("loginPage")
    showNotification("Goodbye :<", type = "message")
  })
  
  observeEvent(input$logoutConfirm, {
    showModal(
      modalDialog(
        title = "Logout?",
        "Are you sure you want Logout?",
        easyClose = TRUE,
        footer = tagList(
          modalButton("Cancel"),
          actionButton("logoutBtn", "Logout", class = "px-5 py-2 rounded-md bg-orange-600 text-white hover:bg-orange-700")
        )
      )
    )
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
        tags$img(
          src = "loadingAi.png",
          class = "d-block mx-auto",  
          style = "width: 300px; height: auto;"  
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
            class = "text-3xl font-semibold text-orange-600 text-center mb-4",
            "🎌 Anime Recommendations"
          ),
          
          # Box container
          tags$div(
            style = "
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            background-color: #ffffff;
            padding: 2rem;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            max-height: 70vh;
            overflow-y: auto;
          ",
            
            tags$div(
              style = "font-size: 1.5rem; line-height: 1.8;",
              HTML(markdown::markdownToHTML(text = ai_text, fragment.only = TRUE))
            )
          ),
          
          footer = modalButton("Close"),
          easyClose = TRUE,
          size = "l"
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
