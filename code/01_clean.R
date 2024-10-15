library(esadeecpol)

# Import data
files <- list.files(path = 'input/raw', pattern = "*.csv", full.names = TRUE)
df <- do.call(rbind, lapply(files, read_csv))

rm(files)


# Clean data
df <- df |> 
    separate(price, into = c('price', 'garaje'), sep = '\\€/mes') |> 
    mutate(
        price = gsub("\\.", '', price),
        price = as.numeric(price),
        garaje = ifelse(str_detect(garaje, 'incluido'), TRUE, FALSE), 
        habitaciones = str_extract(characteristics, "\\d+ hab\\."), 
        habitaciones = str_extract(habitaciones, "\\d+"), 
        habitaciones = ifelse(is.na(habitaciones), 0, habitaciones), 
        habitaciones = as.numeric(habitaciones),
        size = str_extract(characteristics, "\\d+ m²"), 
        size = str_extract(size, "\\d+"), 
        size = as.numeric(size), 
        planta = str_extract(characteristics, "Planta \\d+ª"), 
        planta = str_extract(planta, "\\d+"), 
        planta = ifelse(is.na(planta), 0, planta), 
        planta = as.numeric(planta), 
        ascensor = ifelse(str_detect(characteristics, ' con ascensor'), TRUE, FALSE), 
        exterior = ifelse(str_detect(characteristics, 'exterior'), TRUE, FALSE), 
        photos = str_extract(num_photos, "(?<=/).*"), 
        photos = ifelse(is.na(photos), 0, photos), 
        photos = as.numeric(photos),
        alquiler_temporal = ifelse(str_detect(extra_characteristics, 'temporada'), TRUE, FALSE), 
        alquiler_temporal = ifelse(is.na(alquiler_temporal), FALSE,  alquiler_temporal), 
        agency = ifelse(!is.na(inmobiliaria), TRUE, FALSE)) |> 
    select(date:garaje, habitaciones:alquiler_temporal, agency, inmobiliaria, barrio, id, city) |> 
    mutate(city = case_when(
        city == 'a-coruna' ~ 'A Coruña',
        city == 'barcelona' ~ 'Barcelona',
        city == 'bilbao' ~ 'Bilbao',
        city == 'donostia-san-sebastian' ~ 'San sebastián',
        city == 'madrid' ~ 'Madrid',
        city == 'malaga' ~ 'Málaga',
        city == 'palma-de-mallorca' ~ 'Palma de Mallorca',
        city == 'sevilla' ~ 'Sevilla',
        city == 'valencia' ~ 'Valencia'
    )) |> 
    distinct()


# Export data in RDS and CSV formats
saveRDS(df, 'input/data/clean_data.rds')    
write_csv(df, 'input/data/clean_data.csv')
