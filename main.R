# main.R
libs <- list("dplyr", "googlePolylines", "googleway", "ggspatial", "ggrepel",
             "ggplot2", "rjson", "rlang", "stringr", "tibble", "tidyr", "spatial",
             "sp", "sf", "scales", "prettymapr", "stats", "graphics", "purrr", 
             "grDevices", "utils", "datasets", "methods", "base", "rnaturalearth",
             "rnaturalearthdata", "ggmap", "mapproj", "readr", "readxl", "mapsf",
             "cartography", "arcgisbinding", "arcpullr", "geojsonsf")
all(lapply(libs, library, character.only = T, logical = T))
register_google(key = "AIzaSyDBIxi0iaVEmzKVpGO9CrNTZ9kVxX3_dN8")
sp::plot(ne_states(country = "united states of america")) 
(rnaturalearthhires::states10 |> filter(admin == "United States of America", 
                                        type == "State", 
                                        gn_name == "Florida")) -> florida
# get_map("florida", zoom = 6, maptype = "terrain-background") |> 
#   ggmap()
data <- readxl::read_xlsx("data/florida_inflow.xlsx")
data$`Number of individuals [1]` <- as.numeric(data$`Number of individuals [1]`)
data$`Number of returns` <- as.numeric(data$`Number of returns`)
data$`Adjusted gross income (AGI)` <- as.numeric(data$`Adjusted gross income (AGI)`)
county_codes <- read.csv("data/county_codes.csv", col.names = c("code", "name"), header = F)
county_codes$name |> 
  stringr::str_to_lower() |> 
  sapply((\(x) paste0("florida,", x))) |> 
  as.vector() -> 
  county_codes$longname

by <- join_by(`Destination into Florida County Code` == code)
left_join(data, county_codes, by) -> county_data

county_data |>
  group_by(longname) |>
  summarize(`Adjusted gross income (AGI)` = sum(`Adjusted gross income (AGI)`, 
                                                na.rm = T)) ->
  county_data_summarized

county_data_summarized |> mutate(coord = geocode(longname)) ->
  county_data_summarized_geocoded

# florida <- get_map('florida', zoom = 7) 
# floridaMap <- ggmap(florida, extent = 'device', legend = 'topleft')

floridaMap + geom_density_2d(aes(x = coord$lon, y = coord$lat,
                                fill = after_stat(density)), 
                             data = county_data_summarized_geocoded, 
                             geom = 'polygon') 

scale_fill_gradient('Violent\nCrime\nDensity') +
  scale_alpha(range = c(.4, .75), guide = FALSE) +
  guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10))

map_id <- "80aba8feca084c8c80ca93aa25bd8966"
get_spatial_layer("https://www.arcgis.com/home/item.html?id=f176efeb9983461fb86cd459ee8a5597")

wdnr_server <-"https://dnrmaps.wi.gov/arcgis/rest/services/"
counties <- "DW_Map_Dynamic/EN_Basic_Basemap_WTM_Ext_Dynamic_L16/MapServer/3"
counties_url <- paste(wdnr_server,counties,sep ="/")
get_spatial_layer(counties_url) |> plot()
get_spatial_layer("https://hub.arcgis.com/maps/4c28279c47af46b2a01cfc4beaadd7af")