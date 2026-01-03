tableServer <- function(id, con, current_edit, anime_data) {
  moduleServer(id, function(input, output, session) {
  
    output$anime_table <- renderReactable({
      data <- anime_data() 
      
      data$action <- NA
      
      reactable(
        data,
        columns = list(
          id = colDef(show = FALSE),
          name = colDef(name = "Anime Name", minWidth = 300, align = "center"),
          genre = colDef(name = "Genre", minWidth = 250, align = "center"),
          finished = colDef(
            name = "Finished?",
            minWidth = 50,
            align = "center",
            cell = function(value) ifelse(value == 1, "Yes", "No")
          ),
          rating = colDef(
            name = "Rating",
            minWidth = 50,
            align = "center",
            cell = function(value) paste0(value, "/5")
          ),
          action = colDef(
            name = "Action",
            minWidth = 100,
            align = "center",
            cell = function(value, index) {
              htmltools::tags$button(
                "Edit",
                class = "text-orange-600 hover:text-orange-700",
                onclick = sprintf(
                  "Shiny.setInputValue('%s', %d, {priority: 'event'})",
                  session$ns("edit_row"),
                  data$id[index]
                )
              )
            }
          )
        ),
        searchable = TRUE,
        sortable = TRUE,
        bordered = TRUE,
        defaultPageSize = 10
      )
    }) 
    
    observeEvent(input$edit_row, {
      row_id <- input$edit_row
      current_edit(row_id)
      
      # Fetch row data
      row_data <- DBI::dbGetQuery(
        con,
        glue::glue_sql("SELECT * FROM anime_watchlist WHERE id = {row_id}", .con = con)
      )
      
      # Show modal with pre-filled data
      showModal(
        editModalUI(
          "editModal",
          name = row_data[1, "name"],
          rating = row_data[1, "rating"],
          genre = row_data[1, "genre"],
          finished = row_data[1, "finished"]
        )
      )
    })
    
    
  })  
}  
