animeModalUI <- function(id, title, synopsis, youtube, poster, category, airdate) {
  tags$div(
    id = id,
    tabindex = "-1",
    class = "fixed inset-0 z-50 flex items-center justify-center overflow-y-auto",
    
    # Backdrop (click to close)
    tags$div(
      class = "fixed inset-0 bg-black bg-opacity-50",
      onclick = sprintf("
        document.getElementById('%s').style.display = 'none';
        document.body.style.overflow = 'auto';
      ", id)
    ),
    
    # Modal wrapper
    tags$div(
      class = "relative p-5 w-full max-w-[55vw] max-h-[90vh] z-10 overflow-y-auto",
      tags$div(
        class = "relative bg-white border border-gray-300 rounded-lg shadow-lg p-6",
        
      
        
        # Title
        tags$h2(class = "text-3xl font-bold mb-2 text-center", title),
        
        # ESC note
        tags$p(class = "text-sm text-gray-500 italic text-center mb-6",
               "Press ESC to close this modal."
        ),
        
        # YouTube Trailer (conditionally)
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
    ),
    
    # ESC key handler
    tags$script(HTML(sprintf("
      document.addEventListener('keydown', function(e) {
        if(e.key === 'Escape') {
          var modal = document.getElementById('%s');
          if(modal && modal.style.display !== 'none') {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
          }
        }
      });
    ", id)))
  ) 
}
