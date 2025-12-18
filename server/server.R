animeCards <- function(input, output, session) {
  
  offset <- reactiveVal(0)
  
  anime_data <- reactive({
    fetch_Anime_in_LandingPage(limit = 20, offset = offset())
  })
  
  # Search filter and categories 
  output$animeCategorieswithSearch <- renderUI({
    tags$div(
      class = "flex justify-center mt-6", 
      
      tags$div(
        class = "flex items-center gap-12",  
        
        # Categories on the left
        tags$div(
          class = "flex gap-2 text-gray-500 text-xl font-medium items-center",
          lapply(c("All", "Spring", "Summer", "Fall", "Winter"), function(cat) {
            tags$span(
              class = "cursor-pointer hover:text-orange-600 font-semibold",
              cat,
              if(cat != "Winter") tags$span(class = "mx-2 text-gray-500", "|")
            )
          })
        ),
        
        # Search form 
        tags$form(
          class = "max-w-md flex items-center",
          tags$label(
            `for` = "search",
            class = "sr-only",
            "Search"
          ),
          tags$div(
            class = "relative w-full",
            tags$div(
              class = "absolute inset-y-0 right-3 pr-2 flex items-center ps-3 pointer-events-none",
              HTML('<svg class="w-6 h-6 text-body" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-width="2" d="m21 21-3.5-3.5M17 10a7 7 0 1 1-14 0 7 7 0 0 1 14 0Z"/></svg>')
            ),
            tags$input(
              type = "search",
              id = "search",
              class = "block w-full p-3 pl-15 pr-24 border border-gray-500 text-gray-800 text-xl rounded-md hover:border-orange-600 focus:border-orange-600 focus:outline-none shadow-sm placeholder-gray-400",
              placeholder = "Search",
              required = TRUE
            )
          )
        )
      )
    )
  })
  
  
  output$animeCards <- renderUI({
    data <- anime_data()
    
    if (nrow(data) == 0) return(NULL)
    
    tags$div(
      class = "grid gap-4 px-6 py-3 mt-8
           justify-center
           grid-cols-[repeat(auto-fit,220px)]",
      
      lapply(seq_len(nrow(data)), function(i) {
        
        #Will fetch the id
        actionLink( 
          inputId = paste0("anime_", data$id[i]),
          
        tags$div(
          class = "w-[220px] bg-white rounded-md overflow-hidden transform transition duration-300 ease-in-out hover:scale-105",
          
          tags$img(
            src = data$image[i],
            class = "w-full h-[300px] object-cover"
          ),
          
          tags$div(
            class = "p-3 text-center",
            tags$p(
              class = "text-xl text-gray-500 truncate",
              data$category[i]
            ),
            tags$h2(
              class = "text-2xl font-semibold mb-1 truncate",
              data$title[i]
            )
          )
        )
        )
      })
    )
  })
  
  # --- Pagination UI --- (IMPROVE)
  output$animePagination <- renderUI({
    tags$div(
      class = "flex justify-center mt-6 gap-4", 
      buttonUI("prevBtn", "Back", 3),  # previous button
      buttonUI("nextBtn", "Next", 3)   # next button
    )
  })
  
  observe({
    data <- anime_data()
    req(nrow(data) > 0)
    
    lapply(seq_len(nrow(data)), function(i) {
      local({
        anime_id <- data$id[i]
        input_id <- paste0("anime_", anime_id)
        modal_id <- paste0("popup-modal-", anime_id)
        
        observeEvent(input[[input_id]], {
          # Log click for debugging
          cat("\n==============================\n")
          cat("Anime clicked (ID:", anime_id, ")\n")
          info <- fetch_Anime_Info(anime_id)
          print(info)
          cat("==============================\n")
          
          # Render modal
          output$animeModals <- renderUI({
            animeModalUI(
              id = modal_id,
              title = info$title,
              synopsis = info$synopsis,
              youtube = info$youtube,
              poster = info$poster,
              category = info$category,
              airdate = info$airdate
            )
          })
          
          session$sendCustomMessage(
            type = 'showModal',
            message = list(id = modal_id)
          )
        }, ignoreInit = TRUE)
      })
    })
  })
  
  
  observeEvent(input$nextBtn, {
    offset(offset() + 20)
  })
  
  observeEvent(input$prevBtn, {
    offset(max(offset() - 20, 0))
  })
  
}
