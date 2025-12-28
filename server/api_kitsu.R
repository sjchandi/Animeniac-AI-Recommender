fetch_Anime_in_LandingPage <- function(limit = 10, offset = 0, search = NULL, season = "summer") {
  
  url <- paste0(
    "https://kitsu.io/api/edge/anime?",
    "page[limit]=", limit,
    "&page[offset]=", offset,
    "&include=genres"
  )
  
  if (!is.null(search) && nchar(search) > 0) {
    url <- paste0(url, "&filter[text]=", URLencode(search))
  }
  
  if (!is.null(season) && season %in% c("winter", "spring", "summer", "fall")) {
    url <- paste0(url, "&filter[season]=", URLencode(season))
  }
  
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
