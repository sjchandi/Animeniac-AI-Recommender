animeModalUI <- function(title, synopsis, youtube, poster, category, airdate) {
  modalDialog(
    size = "l",  
    easyClose = TRUE, 
    footer = NULL,   
    tagList(
      # Title
      tags$h2(class = "text-3xl font-bold mb-2 text-center", title),
      
      # ESC note
      tags$p(class = "text-sm text-gray-500 italic text-center mb-6",
             "Press ESC to close this modal."),
      
      # YouTube trailer
      if (!is.null(youtube) && youtube != "") {
        tags$div(
          class = "mt-8 max-w-5xl mx-auto aspect-video rounded-lg shadow-lg overflow-hidden",
          tags$iframe(
            src = paste0("https://www.youtube.com/embed/", youtube),
            class = "w-full h-full",
            frameborder = "0",
            allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
            allowfullscreen = NA
          )
        )
      },
      
      # Poster + Details
      tags$div(
        class = "flex items-start gap-6 mt-8 max-w-5xl mx-auto bg-white rounded-lg shadow-lg p-4",
        
        # Poster
        tags$img(
          src = poster,
          alt = "NoPoster.png",
          class = "w-[220px] h-[320px] object-contain rounded flex-shrink-0"
        ),
        
        # Details
        tags$div(
          class = "flex-1 flex flex-col space-y-2 h-[320px] overflow-y-auto",
          tags$p(class = "text-lg text-gray-700", tags$strong("Air Date: "), airdate),
          tags$p(class = "text-lg text-gray-700", tags$strong("Category: "), category),
          tags$div(class = "text-lg text-gray-700 leading-relaxed", tags$strong("Synopsis: "), synopsis)
        )
      )
    )
  )
}
