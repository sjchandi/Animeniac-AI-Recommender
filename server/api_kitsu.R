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
  
  resp <- request(url) %>% req_perform()
  data_json <- resp %>% resp_body_json(simplifyVector = FALSE)
  
  anime_data <- data_json$data
  included_genres <- data_json$included
  
  genre_map <- if (!is.null(included_genres)) {
    setNames(
      sapply(included_genres, function(g) {
        if (!is.null(g$attributes$name)) g$attributes$name else NA
      }),
      sapply(included_genres, function(g) g$id)
    )
  } else {
    character(0)
  }
  
  result <- lapply(anime_data, function(x) {
    if (is.null(x$attributes)) return(NULL)
    attr <- x$attributes
    
    # Safe genres
    genre_ids <- if (!is.null(x$relationships$genres$data)) {
      sapply(x$relationships$genres$data, function(g) if (!is.null(g$id)) g$id else NA)
    } else {
      character(0)
    }
    genre_names <- if(length(genre_ids) > 0) paste(genre_map[genre_ids], collapse = ", ") else NA
    
    # Safe poster
    poster <- if (!is.null(attr$posterImage) && !is.null(attr$posterImage$medium)) attr$posterImage$medium else "NoPoster.png"
    
    # Safe title
    title <- if (!is.null(attr$canonicalTitle)) attr$canonicalTitle else NA
    
    data.frame(
      id = x$id,
      title = title,
      image = poster,
      category = genre_names,
      stringsAsFactors = FALSE
    )
  })
  
  # Remove any NULL entries
  result <- Filter(Negate(is.null), result)
  if (length(result) == 0) return(data.frame(id=character(0), title=character(0), image=character(0), category=character(0)))
  
  do.call(rbind, result)
}


fetch_Anime_Info <- function(id) {
  url <- paste0("https://kitsu.io/api/edge/anime/", id, "?include=genres")
  resp <- request(url) %>% req_perform()
  data_json <- resp %>% resp_body_json(simplifyVector = FALSE)
  
  if (is.null(data_json$data)) {
    return(list(
      title = NA, synopsis = NA, youtube = NA,
      poster = "NoPoster.png", category = NA, airdate = NA
    ))
  }
  
  x <- data_json$data
  attr <- x$attributes
  included_genres <- data_json$included
  
  # Safe helper
  safe_string <- function(x) {
    if (!is.null(x) && !is.na(x) && nzchar(x)) x else ""
  }
  
  # Genres
  genre_names <- NA
  if (!is.null(x$relationships$genres$data) && length(x$relationships$genres$data) > 0) {
    genre_ids <- sapply(x$relationships$genres$data, function(g) if(!is.null(g$id)) g$id else NA)
    if (!is.null(included_genres)) {
      genre_map <- setNames(
        sapply(included_genres, function(g) safe_string(g$attributes$name)),
        sapply(included_genres, function(g) g$id)
      )
      genre_names <- paste(genre_map[genre_ids], collapse = ", ")
    }
  }
  
  # Poster
  poster <- if (!is.null(attr$posterImage$medium)) attr$posterImage$medium else "NoPoster.png"
  
  # Return safe list
  list(
    title = safe_string(attr$canonicalTitle),
    synopsis = safe_string(attr$synopsis),
    youtube = safe_string(attr$youtubeVideoId),
    poster = poster,
    category = genre_names,
    airdate = safe_string(attr$startDate)
  )
}
