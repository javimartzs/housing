library(esadeecpol)
fonts_ecpol()

df <- tribble(
  ~distrito, ~precio,
  "Arganzuela", 20.2,
  "Barajas", 14.6,
  "Carabanchel", 16,
  "Centro", 24,
  "Chamartín", 20.7, 
  "Chamberí", 23.5, 
  "Ciudad Lineal", 17.2, 
  "Fuencarral", 16.1, 
  "Hortaleza", 15.9, 
  "Latina", 16.7, 
  "Moncloa", 19.7, 
  "Moratalaz", 14.5, 
  "Puente de Vallecas", 16.2, 
  "Retiro", 21.4, 
  "Salamanca", 25, 
  "San Blas", 14.8, 
  "Tetuán", 20.2, 
  "Usera", 17.6, 
  "Vicalvaro", 13.8, 
  "Villa de Vallecas", 14.7, 
  "Villaverde", 15.8)




p <- df |> 
    mutate(
        precio_60 = precio * 60, 
        label = glue('{scales::number(round(precio_60, 1), big.mark = ".", decimal.mark = ",")}€')) |> 
    ggplot(aes(x = precio_60, y = reorder(distrito, precio_60))) +
    geom_bar(stat = "identity", fill = "#225E9C", color = "#225E9C", alpha = 0.2, width = 0.6, linewidth = 0.3) +
    geom_text(aes(label = label), hjust = -0.2, color = "#225E9C", family = 'Mabry Pro Light', size = 2.5) +
    scale_x_continuous(limits = c(0, 1700), labels = function(x) paste0(x, "€")) +
    theme_ecpol() +
    labs(
        title = "Precio medio en el mes de septiembre por un piso de 60 m² en los distritos de Madrid", 
        caption = 'Fuente: elaboración propia a partir de datos de Idealista | @javimartzs') +
    theme(
        plot.title = element_markdown(size = 11, hjust = 1), 
        axis.text.y = element_text(size = 9))

save_to_png(p, 'precio_por_distrito.png')



