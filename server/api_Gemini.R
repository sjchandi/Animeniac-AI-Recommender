aiGeminiResponse <- function(anime_watchlist) {
  api_key <- Sys.getenv("GOOGLE_API_KEY")
  
  url <- "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent"
  
  prompt <- paste0(
    "You are an anime recommendation assistant.\n\n",
    "Based on this anime watchlist:\n",
    anime_watchlist, "\n\n",
    "Recommend EXACTLY 5 anime titles.\n",
    "RULES:\n",
    "- Only list anime titles followed by a one-sentence plot summary\n",
    "- Format: **Anime Name** – Plot summary\n",
    "- Number them 1 to 5\n",
    "- Do not include extra explanations\n",
    "- Start the response with: 'Based on your anime list, we recommend:' followed by a blank line\n"
  )
  
  resp <- httr2::request(url) %>%
    httr2::req_url_query(key = api_key) %>%
    httr2::req_method("POST") %>%
    httr2::req_body_json(list(
      contents = list(
        list(
          parts = list(
            list(text = prompt)
          )
        )
      )
    )) %>%
    httr2::req_perform()
  
  httr2::resp_body_json(resp)$candidates[[1]]$content$parts[[1]]$text
}
