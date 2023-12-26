# main.R
libs <- list("dplyr", "googlePolylines", "googleway", "ggspatial", "ggrepel",
             "ggplot2", "rjson", "rlang", "stringr", "tibble", "tidyr", "spatial",
             "sp", "sf", "scales", "prettymapr", "purrr", "stats", "graphics",
             "grDevices", "utils", "datasets", "methods", "base", "rnaturalearth",
             "rnaturalearthdata", "ggmap")
all(lapply(libs, library, character.only = T, logical = T))
register_google(key = "AIzaSyDBIxi0iaVEmzKVpGO9CrNTZ9kVxX3_dN8")
sp::plot(ne_states(country = "united states of america"))
(rnaturalearthhires::states10 |> filter(admin == "United States of America", 
                                        type == "State", 
                                        gn_name == "Florida"))$geometry |> 
  plot()
# get_map("florida", zoom = 6, maptype = "terrain-background") |> 
#   ggmap()
