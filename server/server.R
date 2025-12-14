source("server/api_kitsu.R") 

server <- function(input, output, session) {
  
  offset <- reactiveVal(0)
  
  anime_data <- reactive({
    fetch_Anime_in_LandingPage(limit = 20, offset = offset())
  })
  
  output$animeCards <- renderUI({
    data <- anime_data()
    
    if(nrow(data) == 0) return(NULL)
    
    cat("Fetched anime data:\n")
    print(data)  
    cat("\n")
    
    
    tags$div(
      style = "display: flex; flex-wrap: wrap; justify-content: flex-start;",
      
      lapply(seq_len(nrow(data)), function(i) {
        tags$div(
          class = "anime-card",
          style = "width: 18%; margin: 1%; background-color: white; 
                 box-shadow: 0 4px 6px rgba(0,0,0,0.1); 
                 border-radius: 10px; overflow: hidden;",
          
          # Anime Poster
          tags$img(
            src = data$image[i], 
            style = "width: 100%; height: 300px; object-fit: cover;"
          ),
          
          # Card content
          tags$div(
            style = "padding: 10px;",
            tags$h2(style = "font-size: 1.1em; font-weight: bold; margin-bottom: 5px;", data$title[i]),
            tags$p(style = "font-size: 0.9em; color: gray;", data$category[i])
          )
        )
      })
    )
  })
  
  
  observeEvent(input$nextBtn, { offset(offset() + 10) })
  observeEvent(input$prevBtn, { offset(max(offset() - 10, 0)) })
}

