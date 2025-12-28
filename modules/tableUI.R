library(DT)

tablelUI <- function(id) {
  ns <- NS(id)
  
  tags$div(
    class = "relative overflow-x-auto bg-neutral-primary-soft shadow-xs rounded-base border border-default p-2",
    reactableOutput(ns("anime_table"))
  )
}
