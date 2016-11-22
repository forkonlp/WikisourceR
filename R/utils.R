#Generic queryin' function for direct Wikisource calls. Wraps around WikipediR::page_content.
wd_query <- function(title, ...){
  result <- WikipediR::page_content(domain = "wikisource.org", page_name = title, as_wikitext = TRUE,
                                    httr::user_agent("WikisourceR - https://github.com/forkonlp/WikisourceR"),
                                    ...)
  output <- jsonlite::fromJSON(result$parse$wikitext[[1]])
  class(output) <- "wikisource"
  return(output)
}

#Query for a random item in "namespace" (ns). Essentially a wrapper around WikipediR::random_page.
wd_rand_query <- function(ns, limit, ...){
  result <- WikipediR::random_page(domain = "Wikisource.org", as_wikitext = TRUE, namespaces = ns,
                                   httr::user_agent("WikisourceR - https://github.com/Ironholds/WikisourceR"),
                                   limit = limit, ...)
  output <- lapply(result, function(x){jsonlite::fromJSON(x$wikitext[[1]])})
  class(output) <- "Wikisource"
  return(output)
  
}

#Generic input checker. Needs additional stuff for property-based querying
#because namespaces are weird, yo.
check_input <- function(input, substitution){
  in_fit <- grepl("^\\d+$",input)
  if(any(in_fit)){
    input[in_fit] <- paste0(substitution, input[in_fit])
  }
  return(input)
}

#Generic, direct access to Wikisource's search functionality.
searcher <- function(search_term, language, limit,  ...){
  url <- WikipediR::url_gen(language,"Wikisource")
  result <- WikipediR::query(url = url, out_class = "list", clean_response = FALSE,
                             query_param = list(
                               action   = "opensearch", 
                               # type   = type,
                               # language = language,
                               limit    = limit,
                               search   = search_term
                             ),
                             ...)
  return(result)
}

# sparql_query <- function(params, ...){
#   result <- httr::GET("https://query.Wikidata.org/bigdata/namespace/wdq/sparql",
#                       query = list(query = params),
#                       httr::user_agent("WikidataR - https://github.com/Ironholds/WikidataR"),
#                       ...)
#   httr::stop_for_status(result)
#   return(httr::content(result, as = "parsed", type = "application/json"))
# }