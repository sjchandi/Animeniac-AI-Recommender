buttonUI <- function(id, text, size = 4, onclick = NULL) {
  actionButton(
    inputId = id,
    label = text,
    class = paste0(
      "bg-orange-600 hover:bg-orange-700 active:bg-orange-700 ",
      "text-white font-bold py-2 px-", size, " rounded transition-all duration-200 ",
      "focus:outline-none focus:ring-0"
    ),
    onclick = onclick
  )
}
