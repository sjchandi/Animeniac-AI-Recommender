tableServer <- function(id, con) {
  moduleServer(id, function(input, output, session) {
    
    output$anime_table <- renderReactable({
      data <- DBI::dbGetQuery(con, "SELECT * FROM anime_watchlist")
      
      data$action <- NA
      
      reactable(
        data,
        columns = list(
          id = colDef(
            show = FALSE
          ),
          name = colDef(
            name = "Anime Name",
            minWidth = 300,
            align = "center",
            style = list(color = "#6B7280")
          ),
          genre = colDef(
            name = "Genre",
            minWidth = 250,
            align = "center",
            style = list(color = "#6B7280")
          ),
          
          finished = colDef(
            name = "Finished?",
            minWidth = 50,
            align = "center",
            style = list(color = "#6B7280"),
            cell = function(value) {
              if (value == 1) "Yes" else "No"
            }
          ),
          rating = colDef(
            name = "Rating",
            minWidth = 50,
            align = "center",
            style = list(color = "#6B7280"),
            cell = function(value) {
              paste0(value, "/5")
            }
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
                  index
                )
              )
            }
          )
        ),
        searchable = TRUE,
        sortable = TRUE,
        highlight = FALSE,
        bordered = TRUE,
        defaultPageSize = 10
      )
    })
    
    observeEvent(input$edit_row, {
      data <- DBI::dbGetQuery(con, "SELECT * FROM anime_watchlist")
      row_index <- input$edit_row
      row_data <- data[row_index, ]
      
      showModal(
        crudModalUI(
          id = "editModal",
          name = row_data$name,
          rating = row_data$rating,
          genre = row_data$genre,
          finished = row_data$finished
        )
      )
    })
    
    
    
    
  })
}

