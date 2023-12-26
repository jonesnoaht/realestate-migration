# main.R
libs <- list("dplyr", "googlePolylines", "googleway", "ggspatial", "ggrepel",
             "ggplot2", "rjson", "rlang", "stringr", "tibble", "tidyr", "spatial",
             "sp", "sf", "scales", "prettymapr", "purrr", "stats", "graphics",
             "grDevices", "utils", "datasets", "methods", "base", "rnaturalearth",
             "rnaturalearthdata")
all(lapply(libs, library, character.only = T, logical = T))
sp::plot(ne_states(country = "united states"))
