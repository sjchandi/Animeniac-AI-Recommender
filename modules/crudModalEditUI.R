editModalUI <- function(id, name = "", rating = 1, genre = "", finished = 0) {
  ns <- NS(id)
  
  modalDialog(
    title = NULL,
    easyClose = TRUE,
    footer = NULL,
    size = "l",
    
    tags$div(
      class = "bg-white rounded-xl p-6 space-y-6",
      
      # Title
      tags$h2(
        class = "text-3xl font-semibold text-gray-800 text-center",
        "Edit Anime"
      ),
      
      # Anime Name
      tags$div(
        tags$label("Anime Name", class = "block text-xl font-medium text-gray-700"),
        tags$input(
          id = ns("name"),
          type = "text",
          value = name,
          class = "mt-1 block w-full rounded-md border border-gray-400 
                   bg-white px-3 py-2 text-gray-500 shadow-sm
                   focus:border-orange-600 focus:ring-orange-600"
        )
      ),
      
      # Genre + Finished
      fluidRow(
        column(
          6,
          tags$label("Genre", class = "block text-xl font-medium text-gray-700"),
          tags$select(
            id = ns("genre"),
            class = "mt-1 mb-10 block w-full rounded-md border border-gray-400 
                     bg-white px-3 py-2 text-gray-500 shadow-sm
                     focus:border-orange-600 focus:ring-orange-600",
            tags$option(value = "", "Select genre"),
            tags$option(value = "Action", "Action"),
            tags$option(value = "Adventure", "Adventure"),
            tags$option(value = "Comedy", "Comedy"),
            tags$option(value = "Drama", "Drama"),
            tags$option(value = "Fantasy", "Fantasy"),
            tags$option(value = "Romance", "Romance"),
            tags$option(value = "Sci-Fi", "Sci-Fi"),
            tags$option(value = "Slice of Life", "Slice of Life"),
            tags$option(value = "Thriller", "Thriller")
          )
        ),
        column(
          6,
          tags$label("Finished Watching?", class = "block text-xl font-medium text-gray-700"),
          tags$select(
            id = ns("finished"),
            value = finished,
            class = "mt-1 block w-full rounded-md border border-gray-400 
                     bg-white px-3 py-2 text-gray-500 shadow-sm
                     focus:border-orange-600 focus:ring-orange-600",
            tags$option(value = 0, "No"),
            tags$option(value = 1, "Yes")
          )
        )
      ),
      
      # Rating Stars
      tags$div(
        tags$label("Rating", class = "block text-xl font-medium text-gray-700 text-center"),
        tags$div(
          id = ns("rating"),
          class = "flex justify-center items-center gap-4 text-5xl cursor-pointer",
          lapply(1:5, function(i) {
            tags$span(
              id = ns(paste0("star_", i)),
              "☆",
              class = "star text-gray-500 hover:text-yellow-500",
              `data-value` = i
            )
          })
        ),
        tags$input(
          id = ns("rating_value"),
          type = "hidden",
          value = rating
        )
      ),
      
      # Buttons
      tags$div(
        class = "flex justify-between gap-3 pt-4",
        
          actionButton(
            inputId = ns("deleteData"),
            label = "Delete",
            class = "px-5 py-2 rounded-md bg-red-600 text-white hover:bg-red-700"
          ),
        
        tags$div(
          
          modalButton("Cancel"),
          
          actionButton(
            inputId = ns("submitEdit"),
            label = "Save Changes",
            class = "px-5 py-2 rounded-md bg-orange-600 text-white hover:bg-orange-700"
          )
        ),
      ),
      
      # JS for rating stars
      tags$script(HTML(sprintf("
        (function() {
          const ratingContainer = document.getElementById('%s');
          if (!ratingContainer) return;
          const stars = ratingContainer.querySelectorAll('.star');
          function updateStars(value) {
            stars.forEach((star, index) => {
              if (index < value) {
                star.textContent = '★';
                star.classList.add('text-yellow-500');
                star.classList.remove('text-gray-500');
              } else {
                star.textContent = '☆';
                star.classList.add('text-gray-500');
                star.classList.remove('text-yellow-500');
              }
            });
          }
          updateStars(%s);
          stars.forEach(star => {
            star.addEventListener('click', function() {
              const value = this.getAttribute('data-value');
              updateStars(value);
              Shiny.setInputValue('%s', value);
            });
          });
        })();
      ", ns("rating"), rating, ns("rating_value"))))
    )
  )
}
