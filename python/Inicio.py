# main.py
import streamlit as st
import pandas as pd
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
        
        
        st.markdown("""
            <style>
                .block-container { padding-top: 1rem; }
                [data-testid="stMetricValue"] { font-size: 1.8rem; }
            </style>
        """, unsafe_allow_html=True)

        if self.df is not None:
            
            st.markdown('<div style="text-align: right;"><p style="font-size: 24px; font-weight: bold; margin: 0;">🚗 Análisis del precio de carros</p></div>', unsafe_allow_html=True)
            st.markdown("<hr style='margin: 10px 0px 20px 0px; opacity: 0.2;'>", unsafe_allow_html=True)

            
            precio_promedio, kilometraje_medio, total_de_carros, marca_lider = st.columns(4)
            precio_promedio.metric("Precio Promedio", f"${self.df['Precio'].mean():,.0f}")
            kilometraje_medio.metric("Kilometraje Medio", f"{self.df['Kilometraje'].mean():,.0f} km")
            total_de_carros.metric("Total de Carros", len(self.df))
            marca_lider.metric("Marca Líder", self.df['Marca'].mode()[0])

            st.write("##") 

           #CUADRÍCULA DE GRÁFICOS (Grid Layout)
            #Precio Anual (60%) y Combustible (40%)
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

            # Marcas (40%) y Dispersión (60%)
            columna_marcas, columna_distribucion_de_precios_por_condicion = st.columns([40, 60])

            with columna_marcas:
                st.subheader("Marcas más Costosas (Promedio)")
                df_marcas = self.df.groupby("Marca")["Precio"].mean().sort_values(ascending=True).reset_index()
                # Gráfico de barras horizontal para mejor lectura de nombres
                fig_marcas = px.bar(df_marcas, x="Precio", y="Marca", orientation='h', color="Precio")
                st.plotly_chart(fig_marcas, use_container_width=True)

            with columna_distribucion_de_precios_por_condicion:
                st.subheader("Distribución de Precios por Condición")
                fig_box = px.box(self.df, x="Condición", y="Precio", color="Condición",
                                title="")
                st.plotly_chart(fig_box, use_container_width=True)
            
            # Dispersión y Correlación 
            st.write("##")
            
            st.subheader("Relación Precio vs. Kilometraje")
            
            fig_scatter = px.scatter(
                self.df, x="Kilometraje", y="Precio", 
                color="Condición", opacity=0.5,
                trendline="ols", 
                hover_data=['Modelo', 'Año']
            )
            st.plotly_chart(fig_scatter, use_container_width=True)

            #  Gráfico de Violín 
            st.subheader("Análisis de Densidad de Precios por Tipo de Combustible")
            fig_violin = px.violin(
                self.df, x="Tipo de Combustible", y="Precio", 
                color="Tipo de Combustible", box=True, points="all"
            )
            st.plotly_chart(fig_violin, use_container_width=True)
        else:
            st.warning("No hay datos cargados para mostrar.")
class Main:
    @staticmethod
    def run():
        st.set_page_config(page_title="Car App", layout="wide")
        
       
        #app = CarApp('./db/data.csv')
        app = CarApp('./db/precios_carros_arreglado.csv')
        
     
        app.cargar_y_limpiar()
        
       
        app.render_ui()
        
        

if __name__ == "__main__":
    Main.run()        
        


