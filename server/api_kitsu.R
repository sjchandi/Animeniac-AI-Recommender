library(httr2)
library(jsonlite)

#Fetching of API data 

fetch_Anime_in_LandingPage = function(limit = 10, offset = 0){
  
  url <- paste0(
    "https://kitsu.io/api/edge/anime?",
    "page[limit]=", limit,
    "&page[offset]=", offset,
    "&include=genres"
  )
  
  # Make request
  resp <- request(url) %>% req_perform()
  
  # Parse JSON
  data_json <- resp %>% resp_body_json(simplifyVector = FALSE)
  
  anime_data <- data_json$data
  included_genres <- data_json$included
  
  genre_map <- setNames(
    sapply(included_genres, function(g) g$attributes$name),
    sapply(included_genres, function(g) g$id)
  )
  
  # Extract useful info
  result <- lapply(anime_data, function(x) {
    attr <- x$attributes
    genre_ids <- sapply(x$relationships$genres$data, function(g) g$id)
    genre_names <- if(length(genre_ids) > 0) paste(genre_map[genre_ids], collapse = ", ") else NA
    
    data.frame(
      id = x$id,
      title = if (!is.null(attr$canonicalTitle)) attr$canonicalTitle else NA,
      image = if (!is.null(attr$posterImage$medium)) attr$posterImage$medium else "NoPoster.png",
      category = genre_names,
      stringsAsFactors = FALSE
    )
  })
  
  do.call(rbind, result)

}


#Will fetch the info of selected anime (NOT FINISHED)
fetch_Anime_Info <- function(id){
  
  url <- paste0("https://kitsu.io/api/edge/anime/", id, "?include=genres")

  resp <- request(url) %>% req_perform()
  data_json <- resp %>% resp_body_json(simplifyVector = TRUE)
  
  anime_data <- data_json$data
  
  # Extract genres from included
  genres <- ""
  if(!is.null(data_json$included)){
    genres <- sapply(data_json$included, function(x) x$attributes$name)
    genres <- paste(genres, collapse = ", ")
  }
  
  SelectedResult <- data.frame(
    title = anime_data$attributes$titles$en_jp,
    synopsis = anime_data$attributes$synopsis,
    youtube = anime_data$attributes$youtubeVideoId,
    genre = genres,
    stringsAsFactors = FALSE
  )
  
  return(SelectedResult)
}