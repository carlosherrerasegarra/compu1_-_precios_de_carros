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

# Limpieza de los datos - Eliminar registros en blanco
df_precioscarros %>% summarise(across(everything(), ~ sum(is.na (.))))
df_precioscarros2 <- df_precioscarros %>% 
  drop_na()

# Limpieza de los datos - Eliminar registros Tesla < 2015
df_precioscarros2 <- df_precioscarros2 %>%
  filter(Brand != "Tesla" | Year >= 2015) %>%
  filter(!(Model == "Model 3" & Year < 2018)) %>%
  filter(!(Model == "Model Y" & Year < 2020))

#Limpieza de los datos - Tesla -> Motor Electrico/ Transmision Automatica / Tamano Motor
df_precioscarros2 <- df_precioscarros2 %>%
  mutate(Fuel.Type = if_else(Brand== "Tesla", "Electric", Fuel.Type)) %>%
  mutate(Transmission = if_else(Brand== "Tesla", "Automatic", Transmission)) %>%
  mutate (Engine.Size = if_else(Brand== "Tesla", NA, Engine.Size))

# Tesla Model S - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Model S" & Year >= 2015 & Year <= 2020, round(runif(n(), min = 30000, max = 58000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Model S" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 55000, max = 85000),2), Price))

# Tesla Model X - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Model X" & Year >= 2015 & Year <= 2020, round(runif(n(), min = 37000, max = 67000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Model X" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 60000, max = 90000),2), Price))

# Tesla Model 3 - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Model 3" & Year >= 2015 & Year <= 2020, round(runif(n(), min = 23000, max = 36000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Model 3" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 30000, max = 44000),2), Price))

# Tesla Model Y - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Model Y" & Year >= 2015 & Year <= 2020, round(runif(n(), min = 37000, max = 50000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Model Y" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 40000, max = 50000),2), Price))

# Tesla Model S - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Model S" & Year >= 2015 & Year <= 2020, round(runif(n(), min = 22000, max = 72000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Model S" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 35000),0), Mileage))

# Tesla Model X - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Model X" & Year >= 2015 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Model X" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 35000),0), Mileage))

# Tesla Model 3 - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Model 3" & Year >= 2015 & Year <= 2020, round(runif(n(), min = 22000, max = 58000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Model 3" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 32000),0), Mileage))

# Tesla Model Y - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Model Y" & Year >= 2015 & Year <= 2020, round(runif(n(), min = 12000, max = 38000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Model Y" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 32000),0), Mileage))

# Limpieza de los datos - Audi A3 - Motores
opciones_combustible <- c("Petrol", "Diesel")
opciones_combustible_Hibrido <- c("Diesel", "Hybrid")
motores_a3_00_03 <- c(1.6, 1.8, 1.9)
motores_a3_04_13 <- c(1.2, 1.4, 1.6, 1.8, 1.9, 2.0, 2.5, 3.2)
motores_a3_04_13_Petrol <- c(1.2, 1.4, 1.8, 2.5, 3.2)
motores_a3_04_13_mixtos <- c(1.6, 2.0)
motores_a3_14_20 <- c(1.0, 1.2, 1.4, 1.5, 1.6, 1.8, 2.0, 2.5)
motores_a3_14_20_Petrol <- c(1.0, 1.2, 1.4, 1.5, 1.8, 2.5)
motores_a3_21_23 <- c(1.0, 1.4, 1.5, 2.0, 2.5)
motores_a3_21_23_Petrol <- c(1.0, 1.5, 2.5)
motores_a3_21_23_Hybrid <- c(1.4, 1.5)

df_precioscarros2 <- df_precioscarros2 %>%
mutate (Engine.Size = if_else (Model == "A3" & Year >= 2021 & Year <= 2023 & Fuel.Type == "Electric", NA, Engine.Size)) 

# Audi A3 2000 - 2003
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "A3" & Year < 2004, sample(motores_a3_00_03, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "A3" & Year < 2004 & Engine.Size== 1.9, "Diesel", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "A3" & Year < 2004 & Engine.Size != 1.9, "Petrol", Fuel.Type ))

# Audi A3 2004 - 2013
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "A3" & Year >= 2004 & Year <= 2013, sample(motores_a3_04_13, n(), replace = TRUE), Engine.Size))  %>%
  mutate (Fuel.Type = if_else (Model == "A3" & Year >= 2004 & Year <= 2013 & Engine.Size %in% motores_a3_04_13_Petrol, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "A3" & Year >= 2004 & Year <= 2013 & Engine.Size == 1.9, "Diesel", Fuel.Type))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "A3" & Year >= 2004 & Year <= 2013 & Engine.Size %in% motores_a3_04_13_mixtos, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type))
  
# Audi A3 2014 - 2020
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "A3" & Year >= 2014 & Year <= 2020, sample(motores_a3_14_20, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "A3" & Year >= 2014 & Year <= 2020 & Engine.Size %in% motores_a3_14_20_Petrol, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "A3" & Year >= 2014 & Year <= 2020 & Engine.Size == 1.6, "Diesel", Fuel.Type))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "A3" & Year >= 2014 & Year <= 2020 & Engine.Size == 2.0, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type))

# Audi A3 - 2021 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate(Engine.Size = if_else(Model == "A3" & Fuel.Type == "Electric", NA_real_, Engine.Size)) %>%
  mutate(Engine.Size = if_else(Model == "A3" & Year >= 2021 & Year <= 2023 & Fuel.Type != "Electric", sample(motores_a3_21_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate(Fuel.Type = if_else(Model == "A3" & Year >= 2021 & Year <= 2023 & Fuel.Type != "Electric" & Engine.Size %in% motores_a3_21_23_Petrol, "Petrol", Fuel.Type)) %>%
  mutate(Fuel.Type = if_else(Model == "A3" & Year >= 2021 & Year <= 2023 & Fuel.Type != "Electric" & Engine.Size %in% motores_a3_21_23_Hybrid, "Hybrid", Fuel.Type)) %>%
  mutate(Transmission = if_else(Model == "A3" & Year >= 2021 & Year <= 2023 & (Fuel.Type == "Electric" | Fuel.Type == "Hybrid"), "Automatic", Transmission))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate(Fuel.Type = if_else(Model == "A3" & Year >= 2021 & Year <= 2023 & Fuel.Type != "Electric" & Engine.Size == 2.0, sample(opciones_combustible_Hibrido, n(), replace = TRUE), Fuel.Type))


# Audi A3 - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A3" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 5000, max = 8500),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A3" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 6000, max = 11000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A3" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 9000, max = 17000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A3" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 14000, max = 26000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A3" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 22000, max = 36000),2), Price))

# Audi A3 - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A3" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 100000, max = 180000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A3" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 90000, max = 140000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A3" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 80000, max = 120000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A3" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 45000, max = 100000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A3" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 40000),0), Mileage))

# Limpieza de los datos - Audi A4 - Motores
motores_a4_00_04 <- c(1.6, 1.8, 2.0, 2.4, 3.0, 4.2, 1.9, 2.5)
motores_a4_00_04_Petrol <- c(1.6, 1.8, 2.0, 2.4, 3.0, 4.2)
motores_a4_00_04_Diesel <- c(1.9, 2.5)
motores_a4_05_07 <- c(1.6, 1.8, 2.0, 3.2, 4.2, 1.9, 2.5, 2.7, 3.0)
motores_a4_05_07_Petrol <- c(1.6, 1.8, 3.2, 4.2)
motores_a4_05_07_Diesel <- c(1.9, 2.5, 2.7, 3.0)
motores_a4_08_15 <- c(1.8, 2.0, 3.0, 3.2, 4.2, 2.7)
motores_a4_08_15_Petrol <- c(1.8, 3.2, 4.2)
motores_a4_08_15_mixtos <- c(2.0, 3.0)
motores_a4_16_23 <- c(1.4, 2.0, 2.9, 3.0)
motores_a4_16_23_Petrol <- c(1.4, 2.9)
motores_a4_16_23_mixtos <- c(2.0, 3.0)

# Audi A4 2000 - 2004
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "A4" & Year < 2005, sample(motores_a4_00_04, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year < 2005 & Engine.Size %in% motores_a4_00_04_Petrol, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year < 2005 & Engine.Size %in% motores_a4_00_04_Diesel, "Diesel", Fuel.Type ))

# Audi A4 2005 - 2007
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "A4" & Year >= 2005 & Year <= 2007, sample(motores_a4_05_07, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year >= 2005 & Year <= 2007 & Engine.Size %in% motores_a4_05_07_Petrol, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year >= 2005 & Year <= 2007 & Engine.Size %in% motores_a4_05_07_Diesel, "Diesel", Fuel.Type ))%>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year >= 2005 & Year <= 2007 & Engine.Size == 2.0, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type ))

#Audi A4 2008 - 2015
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "A4" & Year >= 2008 & Year <= 2015, sample(motores_a4_08_15, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year >= 2008 & Year <= 2015 & Engine.Size %in% motores_a4_08_15_Petrol, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year >= 2008 & Year <= 2015 & Engine.Size == 2.7 , "Diesel", Fuel.Type ))%>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year >= 2008 & Year <= 2015 & Engine.Size %in% motores_a4_08_15_mixtos, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type ))

# Audi A4 2016 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "A4" & Year >= 2016 & Year <= 2023, sample(motores_a4_16_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year >= 2016 & Year <= 2023 & Engine.Size %in% motores_a4_16_23_Petrol, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "A4" & Year >= 2016 & Year <= 2023 & Engine.Size %in% motores_a4_16_23_mixtos, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type ))

# Audi A4 - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A4" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 4500, max = 10000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A4" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 6500, max = 14000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A4" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 10000, max = 22000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A4" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 18000, max = 34000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "A4" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 30000, max = 47000),2), Price))

# Audi A4 - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A4" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 100000, max = 180000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A4" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 140000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A4" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A4" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "A4" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Audi Q7 - Eliminar registros previos a 2007
df_precioscarros2 <- df_precioscarros2 %>%
  filter(!(Model == "Q7" & Year < 2007))

# Audi Q7 - Motores
motores_q7_07_15 <- c(3.0, 3.6, 4.2, 6.0)
motores_q7_07_15_mixtos <- c(3.0, 4.2)
motores_q7_16_23 <- c(2.0, 3.0, 4.0)
opciones_combustible_PHD <- c("Petrol", "Diesel", "Hybrid")

# Audi Q7 - 2007 - 2015
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Q7" & Year < 2016, sample(motores_q7_07_15, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Q7" & Year < 2016 & Engine.Size == 3.6, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "Q7" & Year < 2016 & Engine.Size == 6.0, "Diesel", Fuel.Type )) %>%
  mutate (Fuel.Type = if_else (Model == "Q7" & Year < 2016 & Engine.Size %in% motores_q7_07_15_mixtos, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type ))

# Audi Q7 - 2016 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Q7" & Year >= 2016, sample(motores_q7_16_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Q7" & Year >= 2016 & Engine.Size == 4.0, sample(opciones_combustible,  n(), replace = TRUE), Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "Q7" & Year >= 2016 & Engine.Size == 2.0, sample(opciones_combustible_Hibrido,  n(), replace = TRUE), Fuel.Type )) %>%
  mutate (Fuel.Type = if_else (Model == "Q7" & Year >= 2016 & Engine.Size == 3.0, sample(opciones_combustible_PHD, n(), replace = TRUE), Fuel.Type ))



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
modelos_por_marca2 <- df_precioscarros2 %>%
  group_by(Brand) %>%
  distinct(Model) %>%
  arrange(Brand, Model)
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
modelo_combustible <- df_precioscarros2 %>%
  count (Model, Fuel.Type) %>%
  pivot_wider(names_from = Fuel.Type, values_from = n, values_fill = 0)
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
  summarise(promedio_precio = mean())
