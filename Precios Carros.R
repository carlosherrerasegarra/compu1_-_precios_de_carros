# Cargar paquetes
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)

# Cargar Datos
folder_path <- file.path("C:", "Users", "Viviam Segarra", "Downloads")
file_name <- "6. Precios de Carros.csv"
full_path <- file.path(folder_path, file_name)
df_precioscarros <- read.csv(full_path, header = TRUE, stringsAsFactors = FALSE, na.strings = c("NA", "", " ", "-", "Unknown"))

# Limpieza de los datos
df_precioscarros %>% summarise(across(everything(), ~ sum(is.na (.))))
df_precioscarros2 <- df_precioscarros %>% 
  drop_na()

# Analisis de datos - Conteo Univariado
total_carros <- df_precioscarros2 %>% 
  summarise (Total = n())
carros_por_ano <- df_precioscarros2 %>%
  group_by(Year) %>%
  summarise(Carros = n())
carros_por_marca <- df_precioscarros2 %>%
  group_by(Brand) %>%
  summarise (Carros = n())
modelos_por_marca <- df_precioscarros2 %>%
  group_by (Brand) %>%
  summarise(Modelos = n_distinct(Model))
carros_por_motor <- df_precioscarros2 %>%
  group_by (Engine.Size) %>%
  summarise (Carros = n())
carros_por_transmision <- df_precioscarros2 %>%
  group_by(Transmission) %>%
  summarise (Carros = n())
carros_por_condicion <- df_precioscarros2 %>%
  group_by (Condition) %>%
  summarise (Carros = n())
carros_por_combustible <- df_precioscarros2 %>%
  group_by(Fuel.Type) %>%
  summarise (Carros = n())

# Analisis de datos - Rangos Precio y Millas
corte_precios <- c(0, 10000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, Inf)
etiquetas_precios <- c("0-10k", "10k-20k", "20k-30k", "30k-40k", "40k-50k", "50k-60k", "60k-70k", "70k-80k", "80k-90k", "+90k")
carros_por_rango_precio <- df_precioscarros2 %>%
  mutate(rango_precio = cut(Price, breaks = corte_precios, labels= etiquetas_precios)) %>%
  count(rango_precio)
corte_millas <- c(0, 50000, 100000, 150000, 200000, Inf)
etiquetas_millas <- c("0-50k", "50k-100k", "100k-150k", "150k-200k", "+200k")
carros_por_rango_millas <- df_precioscarros2 %>%
  mutate(rango_millas = cut(Mileage, breaks = corte_millas, labels= etiquetas_millas)) %>%
  count(rango_millas)

# Analisis de datos - Conteo Bivariado
marca_anos <- df_precioscarros2 %>%
  count(Brand, Year) %>%
  pivot_wider(names_from = Year, values_from = n, values_fill = 0)
marca_combustible <- df_precioscarros2 %>%
  count (Brand, Fuel.Type) %>%
  pivot_wider(names_from = Fuel.Type, values_from = n, values_fill = 0)
marca_transmision <- df_precioscarros2 %>%
  count (Brand, Transmission) %>%
  pivot_wider(names_from = Transmission, values_from = n, values_fill = 0)
marca_condicion <- df_precioscarros2 %>%
  count (Brand, Condition) %>%
  pivot_wider(names_from = Condition, values_from = n, values_fill = 0)
ano_combustible <- df_precioscarros2 %>%
  count (Year, Fuel.Type) %>%
  pivot_wider(names_from = Fuel.Type, values_from = n, values_fill = 0)
ano_transmision <- df_precioscarros2 %>%
  count (Year, Transmission) %>%
  pivot_wider(names_from = Transmission, values_from = n, values_fill = 0)
ano_condicion <- df_precioscarros2 %>%
  count (Year, Condition) %>%
  pivot_wider(names_from = Condition, values_from = n, values_fill = 0)

# Analisis de datos - Global Precio
df_precioscarros2 %>%
  summarise(promedio_precio = meam)
