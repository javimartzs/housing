library(esadeecpol)

df <- readRDS('input/data/clean_data.rds') |> 
    filter(date == as.Date('2024-10-15')) |> 
    filter(price < 10000) |> 
    filter(size > 0)


# Precio medio por barrio y numero de habitaciones 
df |> 
    mutate(habs = ifelse(habitaciones > 3, 'Más de 3', as.character(habitaciones))) |> 
    group_by(barrio, habs) |> 
    summarise(
        price = round(mean(price, na.rm = TRUE), 1), 
        city = unique(city)) |> 
    distinct()
    write_csv('output/tables/price_by_rooms_and_barrio.csv')


# Precio medio por barrio, numero de habitaciones y ascensor
df |> 
    mutate(habs = ifelse(habitaciones > 3, 'Más de 3', as.character(habitaciones))) |> 
    group_by(barrio, habs, ascensor) |> 
    summarise(
        price = round(mean(price, na.rm = TRUE), 1), 
        city = unique(city)) |> 
    write_csv('output/tables/price_by_rooms_and_barrio_and_elevator.csv')



# Precio medio por barrio y tamaño
df |> 
    mutate(size = case_when(
        size < 50 ~ 'Menos de 50 m²',
        size < 100 ~ 'Entre 50 y 100 m²',
        size < 150 ~ 'Entre 100 y 150 m²',
        TRUE ~ 'Más de 150 m²')) |> 
    group_by(barrio, size) |> 
    summarise(
        price = round(mean(price, na.rm = TRUE), 1), 
        city = unique(city)) |> 
    write_csv('output/tables/price_by_size_and_barrio.csv')


# Porcentaje de pisos de alquiler temporal por barrio
df |> 
    group_by(barrio, city) |> 
    summarise(
        temporal = mean(alquiler_temporal, na.rm = TRUE),
        total = n()) |> 
    filter(total > 100) |> 
    arrange(desc(temporal))


# Porcentaje de pisos gestionados por agencias
df |> 
    group_by(barrio, city) |> 
    summarise(
        agency = mean(agency, na.rm = TRUE),
        total = n()) |> 
    arrange(desc(agency))



# Precio medio por barrio y metro cuadrado
df |> 
    group_by(barrio, city) |> 
    summarise(
        price_sqm = mean(price / size, na.rm = TRUE),
        total = n()) |> 
    arrange(desc(price_sqm)) |> 
    write_csv('output/tables/price_by_barrio_and_sqm.csv')

