animeCardsUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$div(class = "overflow-x-auto whitespace-nowrap",
             uiOutput(ns("animeCategorieswithSearch")),
             uiOutput(ns("animeCards"))
    ),
    
    uiOutput(ns("animeModals")),
    
    tags$div(class = "flex mt-6 mb-6 justify-center",
             uiOutput(ns("animePagination"))
    )
  )
}
