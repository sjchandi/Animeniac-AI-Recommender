watchlistPageUI <- tagList(
 
  # Navbar
  navbarUI("mainNavbar", currentPage = "watchlistPage"),
  
  tags$div(
    class = "m-10",  # adds margin on all sides for the whole page
  
    # Button
    tags$div(
      class = "flex justify-between mb-5",  
      buttonUI(id = "generate_recommendation", text = "Need Recommendations?", size = 10),
      buttonUI(id = "addButton", text = "Add", size = 10)
    ),
    
    #Table
    tablelUI("anime_table")
  )
)
