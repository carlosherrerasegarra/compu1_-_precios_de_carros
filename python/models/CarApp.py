import streamlit as st
import pandas as pd
from helpers.utils import get_resource_path


class CarApp:
    
    
    def __init__(self, data_path):
        self.data_path = get_resource_path(data_path)
        self.df_original = None  
        self.df = None           
        self.columnas_espanol = {
            'Brand': 'Marca', 'Year': 'Año', 'Engine Size': 'Tamaño del Motor',
            'Fuel Type': 'Tipo de Combustible', 'Transmission': 'Transmisión',
            'Mileage': 'Kilometraje', 'Condition': 'Condición', 'Price': 'Precio',
            'Model': 'Modelo'
        }

    def cargar_y_limpiar(self):
        try:
            self.df_original = pd.read_csv(self.data_path)
            self.df_original = self.df_original.rename(columns=self.columnas_espanol)
            self.df = self.df_original.copy()
        except Exception as e:
            st.error(f"Error al cargar los datos: {e}")

    def aplicar_filtros(self, marcas_sel, rango_año, trans_sel, cond_sel, comb_sel, rango_km):
        query = (
            self.df_original['Marca'].isin(marcas_sel) &
            self.df_original['Año'].between(rango_año[0], rango_año[1]) &
            self.df_original['Condición'].isin(cond_sel) &
            self.df_original['Tipo de Combustible'].isin(comb_sel) &
            self.df_original['Kilometraje'].between(rango_km[0], rango_km[1])
        )
        self.df = self.df_original[query]
        if trans_sel != "Todas":
            self.df = self.df[self.df['Transmisión'] == trans_sel]

