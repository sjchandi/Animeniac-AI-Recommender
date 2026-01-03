animeCardsServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    offset <- reactiveVal(0)
    searchTerm <- reactiveVal("")
    selectedSeason <- reactiveVal("summer")  
    
    anime_data <- reactive({
      # Fetch from API
      data <- fetch_Anime_in_LandingPage(
        limit = 20,
        offset = offset(),
        search = searchTerm(),
        season = selectedSeason()
      )
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
            lapply(c("Spring", "Summer", "Fall", "Winter"), function(cat) {
              tags$span(
                actionLink(
                  inputId = session$ns(paste0("season_", tolower(cat))),
                  label = cat,
                  class = "hover:text-orange-600 font-semibold"
                ),
                if(cat != "Winter") tags$span(class = "mx-2 text-gray-500", "|")
              )
            })
          ),
          
          # Search form 
          output$animeSearchUI <- renderUI({
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
                  id = session$ns("searchInput"),
                  class = "block w-full p-3 pl-15 pr-24 border border-gray-500 text-gray-800 text-xl rounded-md hover:border-orange-600 focus:border-orange-600 focus:outline-none shadow-sm placeholder-gray-400",
                  placeholder = "Search",
                  value = ""
                )
              )
            )
          })
        )
      )
    })
    
    observeEvent(input$searchInput, {
      searchTerm(input$searchInput)
      offset(0)  
    })
    
    
    
    lapply(c("Spring", "Summer", "Fall", "Winter"), function(cat) {
      observeEvent(input[[paste0("season_", tolower(cat))]], {
          selectedSeason(tolower(cat))  
        offset(0)  
      })
    })
    
    #--Output of anime cards--
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
            inputId = session$ns(paste0("anime_", data$id[i])),
            
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
    
    # --- Pagination UI --- 
    output$animePagination <- renderUI({
      tags$div(
        class = "flex justify-center mt-6 gap-4", 
        actionButton(
          inputId = session$ns("prevBtn"),
          label = "Back",
          class = "px-6 py-2 bg-gray-300 rounded-md"
        ),
        
        actionButton(
          inputId = session$ns("nextBtn"),
          label = "Next",
          class = "px-6 py-2 bg-orange-500 text-white rounded-md"
        )
      )
    })
    
    observe({
      data <- anime_data()
      req(nrow(data) > 0)
      
      lapply(seq_len(nrow(data)), function(i) {
        anime_id <- data$id[i]
        local({
          id <- anime_id
          modal_id <- paste0("popup-modal-", id)
          
          observeEvent(input[[paste0("anime_", id)]], {
            modal_id <- paste0("popup-modal-", id)
  
            info <- fetch_Anime_Info(id)
            
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
    
    firstNextClick <- reactiveVal(TRUE)
    
    observeEvent(input$nextBtn, {
      if (firstNextClick()) {
        offset(40)
        firstNextClick(FALSE)
      } else {
        offset(offset() + 20)
      }
    })
    
    
    observeEvent(input$prevBtn, { offset(max(offset() - 20, 0)) })
    
  })
}
