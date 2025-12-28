crudModalServer <- function(id, con) {
  moduleServer(id, function(input, output, session) {
    
    observeEvent(input$submitModal, {
      
      # Get inputs
      anime_name <- input$name
      anime_rating <- as.integer(input$rating_value)
      anime_genre <- input$genre
      anime_finished <- as.integer(input$finished)
      
      # Validation
      if (anime_name == "") {
        showNotification("Please enter anime name!", type = "error")
        return()
      }
      
      if (anime_genre == "") {
        showNotification("Please select a genre!", type = "error")
        return()
      }
      
      
      sql <- glue_sql(
        "INSERT INTO anime_watchlist (name, rating, genre, finished)
         VALUES ({anime_name}, {anime_rating}, {anime_genre}, {anime_finished})",
        .con = con
      )
      
      DBI::dbExecute(con, sql)
      
      removeModal()
      showNotification("Anime added successfully!", type = "message")
      
    })
    
  })
}
