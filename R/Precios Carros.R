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

# Audi Q7 - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Q7" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 10000, max = 18000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Q7" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 15000, max = 30000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Q7" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 24000, max = 55000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Q7" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 50000, max = 80000),2), Price))

# Audi Q7 - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Q7" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 75000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Q7" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Q7" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Q7" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Audi Q5 - Eliminar registros previos a 2008
df_precioscarros2 <- df_precioscarros2 %>%
  filter(!(Model == "Q5" & Year < 2008))

# Audi Q5 - Motores
motores_q5_08_16 <- c(2.0, 3.0, 3.2)
motores_q5_17_23 <- c(2.0, 3.0)

# Audi Q5 - 2008 - 2016
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Q5" & Year < 2017, sample(motores_q5_08_16, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Q5" & Year < 2017 & Engine.Size == 3.2, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "Q5" & Year < 2017 & Engine.Size == 3.0, "Diesel", Fuel.Type )) %>%
  mutate (Fuel.Type = if_else (Model == "Q5" & Year < 2017 & Engine.Size == 2.0, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type ))

# Audi Q5 - 2017 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Q5" & Year >= 2017, sample(motores_q5_17_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Q5" & Year >= 2017 & Engine.Size == 3.0, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type ))  %>%
  mutate (Fuel.Type = if_else (Model == "Q5" & Year >= 2017 & Engine.Size == 2.0, sample(opciones_combustible_PHD, n(), replace = TRUE), Fuel.Type ))

# Audi Q5 - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Q5" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 9000, max = 15000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Q5" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 13000, max = 25000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Q5" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 38000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Q5" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 33000, max = 60000),2), Price))

# Audi Q5 - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Q5" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 70000, max = 140000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Q5" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 45000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Q5" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 15000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Q5" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Toyota RAV4 - Motores
motores_r4_00_05 <- c(1.8, 2.0, 2.4)
motores_r4_00_05_Petrol <- c(1.8, 2.4)
motores_r4_06_12 <- c(2.0, 2.4, 2.5, 3.5, 2.2)
motores_r4_06_12_Petrol <- c(2.0, 2.4, 2.5, 3.5)
motores_r4_13_18 <- c(2.0, 2.5, 2.2)
motores_r4_19_23 <- c(2.0, 2.5)

# Toyota RAV4 - 2000 - 2005
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "RAV4" & Year < 2006, sample(motores_r4_00_05, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year < 2006 & Engine.Size %in% motores_r4_00_05_Petrol, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year < 2006 & Engine.Size == 2.0, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type ))

# Toyota RAV4 - 2006 - 2012
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "RAV4" & Year >= 2006 & Year <= 2012, sample(motores_r4_06_12, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year >= 2006 & Year <= 2012 & Engine.Size %in% motores_r4_06_12_Petrol, "Petrol", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year >= 2006 & Year <= 2012 & Engine.Size == 2.2, "Diesel", Fuel.Type ))
  
# Toyota RAV4 2013 - 2018
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "RAV4" & Year >= 2013 & Year <= 2018, sample(motores_r4_13_18, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year >= 2013 & Year <= 2018 & Engine.Size == 2.0, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year >= 2013 & Year <= 2018 & Engine.Size == 2.5, sample(opciones_combustible_Hibrido, n(), replace = TRUE), Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year >= 2013 & Year <= 2018 & Engine.Size == 2.2, "Diesel", Fuel.Type ))

# Toyota RAV4 - 2019 - 2023
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "RAV4" & Year >= 2019 & Year <= 2023, sample(motores_r4_13_18, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year >= 2019 & Year <= 2023 & Engine.Size == 2.0, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year >= 2019 & Year <= 2023 & Engine.Size == 2.5, sample(opciones_combustible_Hibrido, n(), replace = TRUE), Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "RAV4" & Year >= 2019 & Year <= 2023 & Engine.Size == 2.2, "Diesel", Fuel.Type ))  

#Toyota RAV4 - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "RAV4" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 3000, max = 10000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "RAV4" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 5500, max = 12000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "RAV4" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 9000, max = 17000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "RAV4" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 15000, max = 27000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "RAV4" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 24000, max = 36000),2), Price))

# Toyota - RAV4 - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "RAV4" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 100000, max = 180000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "RAV4" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "RAV4" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "RAV4" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "RAV4" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Toyota Prius - 2000 - 2009
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Prius" & Year < 2010, 1.5, Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Prius" , "Hybrid", Fuel.Type)) %>%
  mutate (Transmission = if_else (Model == "Prius" , "Automatic", Transmission))

# Toyota Prius - 2010 - 2022
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Prius" & Year >= 2010 & Year <= 2022 , 1.8, Engine.Size))

# Toyota Prius - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Prius" & Year == 2023 , 2.0, Engine.Size))

#Toyota Prius - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Prius" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 5000, max = 9000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Prius" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 6500, max = 12000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Prius" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 9000, max = 16000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Prius" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 13000, max = 24000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Prius" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 22000, max = 30000),2), Price))

# Toyota - Prius - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Prius" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 100000, max = 180000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Prius" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Prius" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Prius" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Prius" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

#Toyota Corolla - Motores
motores_corolla_09_13 <- c(2.4, 1.8)
motores_corolla_18_23 <- c(1.8, 2.0)
opciones_combustible_PH <- c("Hybrid", "Petrol")

#Toyota Corolla - 2000
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Corolla" & Year == 2000, 1.6, Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Corolla" & Year >= 2000 & Year <=2018, "Petrol", Fuel.Type))
  
#Toyota Corolla - 2001 - 2008
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Corolla" & Year >= 2001 & Year <=2008, 1.8, Engine.Size))

#Toyota Corolla - 2009 - 2013
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Corolla" & Year >= 2009 & Year <=2013, sample(motores_corolla_09_13, n(), replace = TRUE), Engine.Size))

#Toyota Corolla - 2014 - 2018
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Corolla" & Year >= 2014 & Year <=2018, 1.8, Engine.Size))

#Toyota Corolla - 2019 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Corolla" & Year >= 2019 & Year <=2023, sample(motores_corolla_18_23, n(), replace = TRUE), Engine.Size))%>%
  mutate (Fuel.Type = if_else (Model == "Corolla" & Year >= 2019 & Year <=2023 & Engine.Size == 2.0, "Petrol", Fuel.Type))%>%
  mutate (Fuel.Type = if_else (Model == "Corolla" & Year >= 2019 & Year <=2023 & Engine.Size == 1.8, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type ))

#Toyota Corolla - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Corolla" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 2500, max = 8000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Corolla" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 3500, max = 10000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Corolla" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 6000, max = 15000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Corolla" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 13000, max = 24000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Corolla" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 22000, max = 30000),2), Price))

# Toyota - Corolla - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Corolla" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 100000, max = 180000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Corolla" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Corolla" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Corolla" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Corolla" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Toyota Camry - Motores
motores_camry_00_01 <- c(2.2, 3.0)
motores_camry_02_06 <- c(2.4, 3.0, 3.3)
motores_camry_07_11 <- c(2.0, 2.4, 2.5, 3.5)
motores_camry_12_23 <- c(2.0, 2.5, 3.5)

df_precioscarros2 <- df_precioscarros2 %>%
mutate (Fuel.Type = if_else (Model == "Camry", "Petrol", Fuel.Type))

# Toyota Camry - 2000- 2001
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Camry" & Year < 2002, sample(motores_camry_00_01, n(), replace = TRUE), Engine.Size))

# Toyota Camry - 2002- 2006
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Camry" & Year >= 2002 & Year <= 2006, sample(motores_camry_02_06, n(), replace = TRUE), Engine.Size))

# Toyota Camry - 2007- 2011
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Camry" & Year >= 2007 & Year <= 2011, sample(motores_camry_07_11, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Camry" & Year >= 2007 & Year <=2011 & Engine.Size == 2.4, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type ))

# Toyota Camry - 2012- 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Camry" & Year >= 2012 & Year <= 2023, sample(motores_camry_12_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Camry" & Year >= 2012 & Year <=2023 & Engine.Size == 2.5, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type ))

# Toyota Camry - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Camry" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 3500, max = 8000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Camry" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 5000, max = 11500),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Camry" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 7000, max = 16000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Camry" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 12000, max = 24000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Camry" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 20000, max = 30000),2), Price))

# Toyota - Camry - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Camry" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 100000, max = 180000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Camry" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Camry" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Camry" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Camry" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))


# Ford Explorer - Motores
motores_explorer_00_01 <- c(4.0, 5.0)
motores_explorer_02_10 <- c(4.0, 4.6)
motores_explorer_11_19 <- c(2.0, 2.3, 3.5)
motores_explorer_20_23 <- c(2.3, 3.0, 3.3)

df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "Explorer", "Petrol", Fuel.Type)) %>%
  mutate (Transmission = if_else(Model == "Explorer" & Year > 2001, "Automatic", Transmission))

# Ford Explorer - 2000- 2001
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Explorer" & Year < 2002, sample(motores_explorer_00_01, n(), replace = TRUE), Engine.Size))

# Ford Explorer - 2002- 2010
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Explorer" & Year >= 2002 & Year <= 2010, sample(motores_explorer_02_10, n(), replace = TRUE), Engine.Size))

# Ford Explorer - 2011- 2019
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Explorer" & Year >= 2011 & Year <= 2019, sample(motores_explorer_11_19, n(), replace = TRUE), Engine.Size))

# Ford Explorer - 2020- 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Explorer" & Year >= 2020 & Year <= 2023, sample(motores_explorer_20_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Explorer" & Year >= 2020 & Year <=2023 & Engine.Size == 3.0, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type )) %>%
  mutate (Fuel.Type = if_else (Model == "Explorer" & Year >= 2020 & Year <=2023 & Engine.Size == 3.3, "Hybrid", Fuel.Type ))

# Ford Explorer - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Explorer" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 3500, max = 8000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Explorer" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 5000, max = 11500),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Explorer" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 7000, max = 19000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Explorer" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 12000, max = 30000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Explorer" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 23000, max = 45000),2), Price))

# Ford Explorer - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Explorer" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 110000, max = 200000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Explorer" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 90000, max = 160000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Explorer" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 60000, max = 120000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Explorer" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 75000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Explorer" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 40000),0), Mileage))

# Ford Focus - Motores
motores_focus_00_07 <- c(2.0, 2.3)
motores_focus_12_17 <- c(1.0, 2.0, 2.3)
motores_focus_18_23 <- c(1.0, 1.5, 2.0, 2.3)

df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "Focus", "Petrol", Fuel.Type))

# Ford Focus 2000 - 2007
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Focus" & Year < 2008, sample(motores_focus_00_07, n(), replace = TRUE), Engine.Size))

# Ford Focus 2008 - 2011
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Focus" & Year >= 2008 & Year <= 2011, 2.0, Engine.Size))

# Ford Focus 2012 - 2017
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Focus" & Year >= 2012 & Year <= 2017, sample(motores_focus_12_17, n(), replace = TRUE), Engine.Size))

# Ford Focus 2017 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Focus" & Year >= 2018 & Year <= 2023, sample(motores_focus_18_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Focus" & Year >= 2018 & Year <=2023 & Engine.Size == 1.0, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type )) %>%
  mutate (Fuel.Type = if_else (Model == "Focus" & Year >= 2018 & Year <=2023 & Engine.Size == 2.0, "Diesel", Fuel.Type )) %>%
  mutate (Fuel.Type = if_else (Model == "Focus" & Year >= 2018 & Year <=2023 & Engine.Size == 1.5, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type ))

# Ford Focus - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Focus" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 2500, max = 8000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Focus" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 4000, max = 8500),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Focus" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 6000, max = 14000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Focus" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 8000, max = 16000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Focus" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 14000, max = 23000),2), Price))

# Ford Focus - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Focus" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 110000, max = 200000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Focus" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 90000, max = 160000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Focus" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 60000, max = 120000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Focus" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 75000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Focus" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 40000),0), Mileage))

# Ford Mustang - Motores
motores_mustang_00_04 <- c(3.8, 3.9, 4.6, 5.4)
motores_mustang_05_09 <- c(4.0, 4.6, 5.4)
motores_mustang_10_14 <- c(3.7, 4.0, 4.6, 5.0, 5.4, 5.8)
motores_mustang_15_23 <- c(2.3, 3.7, 5.0, 5.2)

df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "Mustang", "Petrol", Fuel.Type))

# Ford Mustang 2000 - 2004
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Mustang" & Year < 2005, sample(motores_mustang_00_04, n(), replace = TRUE), Engine.Size))

# Ford Mustang 2005 - 2009
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Mustang" & Year >= 2005 & Year <= 2009, sample(motores_mustang_05_09, n(), replace = TRUE), Engine.Size))

# Ford Mustang 2010 - 2014
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Mustang" & Year >= 2010 & Year <= 2014, sample(motores_mustang_10_14, n(), replace = TRUE), Engine.Size))

# Ford Mustang 2015 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Mustang" & Year >= 2015 & Year <= 2023, sample(motores_mustang_15_23, n(), replace = TRUE), Engine.Size))

# Ford Mustang - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Mustang" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 4500, max = 11000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Mustang" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 6000, max = 15000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Mustang" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 10000, max = 24000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Mustang" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 17000, max = 35000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Mustang" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 27000, max = 50000),2), Price))

# Ford Mustang - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Mustang" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 110000, max = 180000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Mustang" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 160000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Mustang" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 120000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Mustang" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 15000, max = 80000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Mustang" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Ford Fiesta
motores_fiesta_00_02 <- c(1.0, 1.2, 1.4, 1.5, 1.6)
motores_fiesta_03_08 <- c(1.3, 1.4, 1.6, 2.0)
motores_fiesta_09_17 <- c(1.0, 1.25, 1.4, 1.5, 1.6)
motores_fiesta_09_17_mixtos <- c(1.4, 1.5, 1.6)
motores_fiesta_18_23 <- c(1.0, 1.1, 1.5)

df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "Fiesta", "Petrol", Fuel.Type))

# Ford Fiesta 2000 - 2002
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Fiesta" & Year < 2003, sample(motores_fiesta_00_02, n(), replace = TRUE), Engine.Size))

# Ford Fiesta 2003 - 2008
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Fiesta" & Year >= 2003 & Year <= 2008, sample(motores_fiesta_03_08, n(), replace = TRUE), Engine.Size))

# Ford Fiesta 2009 - 2017
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Fiesta" & Year >= 2009 & Year <= 2017, sample(motores_fiesta_09_17, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Fiesta" & Year >= 2009 & Year <= 2017 & Engine.Size %in% motores_fiesta_09_17_mixtos, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type))

# Ford Fiesta 2018 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Fiesta" & Year >= 2018 & Year <= 2023, sample(motores_fiesta_18_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Fiesta" & Year >= 2018 & Year <= 2023 & Engine.Size == 1.5, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "Fiesta" & Year >= 2018 & Year <= 2023 & Engine.Size == 1.0, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type))

# Ford Fiesta - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fiesta" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 1500, max = 3500),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fiesta" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 3000, max = 7000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fiesta" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 5000, max = 10000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fiesta" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 7000, max = 13000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fiesta" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 10000, max = 20000),2), Price))

# Ford Fiesta - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fiesta" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 110000, max = 180000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fiesta" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 160000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fiesta" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fiesta" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fiesta" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Honda Accord - Motores
motores_accord_00_02 <- c(2.0, 2.3, 3.0)
motores_accord_03_07 <- c(2.0, 2.4, 3.0)
motores_accord_08_12 <- c(2.0, 2.2, 2.4, 3.5)
motores_accord_13_17 <- c(2.0, 2.4, 3.5)
motores_accord_18_23 <- c(1.5, 2.0)

df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "Accord", "Petrol", Fuel.Type))

# Honda Accord 2000 - 2002
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Accord" & Year < 2003, sample(motores_accord_00_02, n(), replace = TRUE), Engine.Size))

# Honda Accord 2003 - 2007
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Accord" & Year >= 2003 & Year <= 2007, sample(motores_accord_03_07, n(), replace = TRUE), Engine.Size))

# Honda Accord 2008 - 2012
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Accord" & Year >= 2008 & Year <= 2012, sample(motores_accord_08_12, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Accord" & Year >= 2018 & Year <= 2023 & Engine.Size == 2.2, "Diesel", Fuel.Type))

# Honda Accord 2013 - 2017
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Accord" & Year >= 2013 & Year <= 2017, sample(motores_accord_13_17, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Accord" & Year >= 2013 & Year <= 2017 & Engine.Size == 2.0, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type))

# Honda Accord 2018 - 2022
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Accord" & Year >= 2018 & Year <= 2022, sample(motores_accord_18_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Accord" & Year >= 2018 & Year <= 2022 & Engine.Size == 2.0, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type))

# Honda Accord 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Accord" & Year == 2023, sample(motores_accord_18_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Accord" & Year == 2023 & Engine.Size == 2.0, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type))

# Honda Accord - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Accord" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 3500, max = 8000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Accord" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 5000, max = 10000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Accord" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 7500, max = 14000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Accord" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 12000, max = 22000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Accord" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 20000, max = 30000),2), Price))

# Honda Accord - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Accord" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 110000, max = 190000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Accord" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Accord" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Accord" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Accord" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Honda Fit - Motores
motores_fit_00_08 <- c(1.2, 1.3, 1.5)
motores_fit_09_13 <- c(1.3, 1.5)
motores_fit_14_20 <- c(1.2, 1.3, 1.5)
motores_fit_21_23 <- c(1.3, 1.5)

df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "Fit", "Petrol", Fuel.Type))

# Honda Fit 2000 - 2008
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Fit" & Year < 2009, sample(motores_fit_00_08, n(), replace = TRUE), Engine.Size))
 

# Honda Fit 2009 - 2013
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Fit" & Year >= 2009 & Year <= 2013, sample(motores_fit_09_13, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Fit" & Year >= 2009 & Year <= 2013, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type))

# Honda Fit 2014 - 2020
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Fit" & Year >= 2014 & Year <= 2020, sample(motores_fit_14_20, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Fit" & Year >= 2014 & Year <= 2020 & Engine.Size == 1.5, "Hybrid", Fuel.Type))

# Honda Fit 2021 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Fit" & Year >= 2021 & Year <= 2023, sample(motores_fit_14_20, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Fit" & Year >= 2021 & Year <= 2023 & Engine.Size == 1.3, "Hybrid", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "Fit" & Year >= 2021 & Year <= 2023 & Engine.Size == 1.5, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type))

# Honda Fit - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fit" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 3500, max = 6000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fit" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 4500, max = 10000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fit" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 7000, max = 14000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fit" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 10000, max = 21000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Fit" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 18000, max = 27000),2), Price))

# Honda Fit - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fit" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 100000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fit" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fit" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fit" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Fit" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Honda Civic - Motores
motores_civic_00 <- c(1.3, 1.4, 1.5, 1.6, 1.8, 2.0)
motores_civic_01_05 <- c(1.4, 1.5, 1.6, 1.7, 1.3)
motores_civic_06_11 <- c(1.6, 1.8, 2.0, 1.3)
motores_civic_12_16 <- c(1.6, 1.8, 2.0, 2.4, 1.5)
motores_civic_17_21 <- c(1.0, 1.5, 1.6, 1.8, 2.6)
motores_civic_22_23 <- c(1.5, 2.0)

df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "Civic", "Petrol", Fuel.Type))

# Honda Civic 2000
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Civic" & Year == 2000, sample(motores_civic_00, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Civic" & Year == 2000 & Engine.Size == 2.0, "Diesel", Fuel.Type))    

# Honda Civic 2001 - 2005
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Civic" & Year >= 2001 & Year <= 2005, sample(motores_civic_01_05, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Civic" & Year >= 2001 & Year <= 2005 & Engine.Size == 1.7, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type))  %>%
  mutate (Fuel.Type = if_else (Model == "Civic" & Year >= 2001 & Year <= 2005 & Engine.Size == 1.3, "Hybrid", Fuel.Type))

# Honda Civic 2006 - 2011
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Civic" & Year >= 2006 & Year <= 2011, sample(motores_civic_06_11, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Civic" & Year >= 2006 & Year <= 2011 & Engine.Size == 1.3, "Hybrid", Fuel.Type))

# Honda Civic 2012 - 2016
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Civic" & Year >= 2012 & Year <= 2016, sample(motores_civic_12_16, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Civic" & Year >= 2012 & Year <= 2016 & Engine.Size == 1.5, "Hybrid", Fuel.Type))

# Honda Civic 2017 - 2021
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Civic" & Year >= 2017 & Year <= 2021, sample(motores_civic_17_21, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Civic" & Year >= 2017 & Year <= 2021 & Engine.Size == 1.6, sample(opciones_combustible, n(), replace = TRUE), Fuel.Type))


# Honda Civic 2022 - 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "Civic" & Year >= 2022 & Year <= 2023, sample(motores_civic_22_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "Civic" & Year >= 2022 & Year <= 2023 & Engine.Size == 2.0, sample(opciones_combustible_PH, n(), replace = TRUE), Fuel.Type))

# Honda Civic - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Civic" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 3500, max = 7500),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Civic" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 4500, max = 10000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Civic" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 7000, max = 14000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Civic" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 10000, max = 21000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "Civic" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 18000, max = 27000),2), Price))

# Honda Civic - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Civic" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 110000, max = 190000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Civic" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Civic" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Civic" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "Civic" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))

# Honda CR-V - Motores
motores_crv_02_16 <- c(2.0, 2.4, 2.2)
motores_crv_17_22 <- c(1.5, 2.0, 2.4, 1.6)
motores_crv_23 <- c(1.5, 2.0)

df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Fuel.Type = if_else (Model == "CR-V", "Petrol", Fuel.Type))

# Honda CR-V 2000 - 2001
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "CR-V" & Year <= 2001, 2.0, Engine.Size))

# Honda CR-V 2002 - 2016
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "CR-V" & Year >= 2002 & Year <= 2016, sample(motores_crv_02_16, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "CR-V" & Year >= 2002 & Year <= 2016 & Engine.Size == 2.2, "Diesel", Fuel.Type))

# Honda CR-V 2017 - 2022
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "CR-V" & Year >= 2017 & Year <= 2022, sample(motores_crv_17_22, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "CR-V" & Year >= 2017 & Year <= 2022 & Engine.Size == 1.6, "Diesel", Fuel.Type)) %>%
  mutate (Fuel.Type = if_else (Model == "CR-V" & Year >= 2017 & Year <= 2022 & Engine.Size == 2.0, "Hybrid", Fuel.Type))

# Honda CR-V 2023
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Engine.Size = if_else (Model == "CR-V" & Year == 2023, sample(motores_crv_23, n(), replace = TRUE), Engine.Size)) %>%
  mutate (Fuel.Type = if_else (Model == "CR-V" & Year == 2023 & Engine.Size == 2.0, "Hybrid", Fuel.Type))

# Honda CR-V - Precios Nuevos
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "CR-V" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 3500, max = 8000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "CR-V" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 5000, max = 12000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "CR-V" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 8000, max = 17000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "CR-V" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 12000, max = 25000),2), Price))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Price = if_else(Model == "CR-V" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 21000, max = 35000),2), Price))

# Honda CR-V - Millaje Nuevo
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "CR-V" & Year >= 2000 & Year <= 2005, round(runif(n(), min = 110000, max = 190000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "CR-V" & Year >= 2006 & Year <= 2010, round(runif(n(), min = 80000, max = 150000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "CR-V" & Year >= 2011 & Year <= 2015, round(runif(n(), min = 50000, max = 110000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "CR-V" & Year >= 2016 & Year <= 2020, round(runif(n(), min = 20000, max = 70000),0), Mileage))
set.seed(125)
df_precioscarros2 <- df_precioscarros2 %>%
  mutate (Mileage = if_else(Model == "CR-V" & Year >= 2021 & Year <= 2023, round(runif(n(), min = 5000, max = 30000),0), Mileage))




write_csv(df_precioscarros2, "precios_carros.csv")


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
