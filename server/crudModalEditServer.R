crudModalEditServer <- function(id, con, record_id, anime_data ) {
  moduleServer(id, function(input, output, session) {
    
    observeEvent(input$submitEdit, {
    
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
      
      sql <- glue::glue_sql(
        "UPDATE anime_watchlist
         SET name = {anime_name},
             rating = {anime_rating},
             genre = {anime_genre},
             finished = {anime_finished}
         WHERE id = {record_id()}",
        .con = con
      )
      
      DBI::dbExecute(con, sql)
      anime_data(DBI::dbGetQuery(con, "SELECT * FROM anime_watchlist"))
      removeModal()
      showNotification("Anime updated successfully!", type = "message")
    })
    
    # Delete record
    observeEvent(input$deleteData, {
      req(record_id())  # make sure record_id is not NULL
      showModal(
        modalDialog(
          title = "Confirm Delete",
          "Are you sure you want to delete this anime?",
          easyClose = TRUE,
          footer = tagList(
            modalButton("Cancel"),
            actionButton(session$ns("confirmDelete"), "Delete", class = "btn btn-danger")
          )
        )
      )
    })
    
    # Confirm delete
    observeEvent(input$confirmDelete, {
      sql <- glue::glue_sql(
        "DELETE FROM anime_watchlist WHERE id = {record_id()}",
        .con = con
      )
      DBI::dbExecute(con, sql)
      removeModal()
      anime_data(DBI::dbGetQuery(con, "SELECT * FROM anime_watchlist"))
      showNotification("Anime deleted successfully!", type = "message")
    })
    
    
  })
}
