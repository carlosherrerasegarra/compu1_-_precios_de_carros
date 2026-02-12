# main.py
import streamlit as st
import pandas as pd
from components.Column_Chart import column_chart
import plotly.express as px

class CarApp:
    def __init__(self, data_path):
        self.data_path = data_path
        self.df = None
        self.columnas_espanol = {
            'Brand': 'Marca',
            'Year': 'Año',
            'Engine Size': 'Tamaño del Motor',
            'Fuel Type': 'Tipo de Combustible',
            'Transmission': 'Transmisión',
            'Mileage': 'Kilometraje',
            'Condition': 'Condición',
            'Price': 'Precio',
            'Model': 'Modelo'
        }

    def cargar_y_limpiar(self):
        """Carga los datos y renombra las columnas."""
        try:
            self.df = pd.read_csv(self.data_path)
            self.df = self.df.rename(columns=self.columnas_espanol)
        except FileNotFoundError:
            st.error(f"No se encontró el archivo en: {self.data_path}")

    def render_ui(self):
        
        # Inyectamos CSS para que el contenedor principal use mejor el espacio
        st.markdown("""
            <style>
                .block-container { padding-top: 1rem; }
                [data-testid="stMetricValue"] { font-size: 1.8rem; }
            </style>
        """, unsafe_allow_html=True)

        if self.df is not None:
            # 1. ENCABEZADO: Título a la derecha y métricas rápidas
            st.markdown('<div style="text-align: right;"><p style="font-size: 24px; font-weight: bold; margin: 0;">🚗 Análisis del precio de carros</p></div>', unsafe_allow_html=True)
            st.markdown("<hr style='margin: 10px 0px 20px 0px; opacity: 0.2;'>", unsafe_allow_html=True)

            # 2. MÉTRICAS CLAVE (Fila superior para dar contexto rápido)
            precio_promedio, kilometraje_medio, total_de_carros, marca_lider = st.columns(4)
            precio_promedio.metric("Precio Promedio", f"${self.df['Precio'].mean():,.0f}")
            kilometraje_medio.metric("Kilometraje Medio", f"{self.df['Kilometraje'].mean():,.0f} km")
        

            st.write("##") # Espaciador

            # 3. CUADRÍCULA DE GRÁFICOS (Grid Layout)
            # Fila 1: Precio Anual (60%) y Combustible (40%)
            columna_evolucion_de_precios_por_año, columna_tipo_de_combustible = st.columns([60, 40])
            
            with columna_evolucion_de_precios_por_año:
                st.subheader("Evolución de Precios por Año")
                df_promedio = self.df.groupby("Año")["Precio"].mean().reset_index()
                st.bar_chart(data=df_promedio, x="Año", y="Precio", color="#1f77b4")

            with columna_tipo_de_combustible:
                st.subheader("Mezcla de Combustible")
                df_fuel = self.df["Tipo de Combustible"].value_counts().reset_index()
                fig_pie = px.pie(df_fuel, values='count', names='Tipo de Combustible', hole=0.5)
                fig_pie.update_layout(margin=dict(t=0, b=0, l=0, r=0))
                st.plotly_chart(fig_pie, use_container_width=True)

        
        else:
            st.warning("No hay datos cargados para mostrar.")
class Main:
    @staticmethod
    def run():
        st.set_page_config(page_title="Car App", layout="wide")
        
        # 1. Instanciar la lógica de la app
        app = CarApp('./db/data.csv')
        
        # 2. Ejecutar procesos iniciales
        app.cargar_y_limpiar()
        
        # 3. Lanzar la interfaz
        app.render_ui()
        
        
# Punto de entrada estándar de Python
if __name__ == "__main__":
    Main.run()        
        


