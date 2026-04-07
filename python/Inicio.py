# main.py actualizado con filtros
import streamlit as st
import pandas as pd
import plotly.express as px
import os
import sys

def get_resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)

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

    def aplicar_filtros(self):
        """Crea la barra lateral con filtros dinámicos."""
        st.sidebar.header("🔍 Filtros de Búsqueda")
        
        marcas = sorted(self.df_original['Marca'].unique())
        marcas_sel = st.sidebar.multiselect("Selecciona Marcas", marcas, default=marcas)

        año_min, año_max = int(self.df_original['Año'].min()), int(self.df_original['Año'].max())
        rango_año = st.sidebar.slider("Rango de Año", año_min, año_max, (año_min, año_max))

        transmisiones = ["Todas"] + list(self.df_original['Transmisión'].unique())
        trans_sel = st.sidebar.selectbox("Transmisión", transmisiones)

        condiciones = self.df_original['Condición'].unique()
        cond_sel = st.sidebar.multiselect("Condición", condiciones, default=list(condiciones))

        combustibles = self.df_original['Tipo de Combustible'].unique()
        comb_sel = st.sidebar.multiselect("Tipo de Combustible", combustibles, default=list(combustibles))

        km_min, km_max = int(self.df_original['Kilometraje'].min()), int(self.df_original['Kilometraje'].max())
        rango_km = st.sidebar.slider("Kilometraje Máximo", km_min, km_max, (km_min, km_max))

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

    def render_ui(self):
        st.markdown("""
            <style>
                .block-container { padding-top: 1rem; }
                [data-testid="stMetricValue"] { font-size: 1.8rem; color: #1f77b4; }
            </style>
        """, unsafe_allow_html=True)

        if self.df is not None and not self.df.empty:
            st.markdown('<div style="text-align: right;"><p style="font-size: 24px; font-weight: bold; margin: 0;">🚗 Dashboard de Precios de Vehículos</p></div>', unsafe_allow_html=True)
            st.markdown("<hr style='margin: 10px 0px 20px 0px; opacity: 0.2;'>", unsafe_allow_html=True)

            
            highlight_promedio, highlight_kilometraje_promedio, highlight_vehiculos_filtrados, highlight_marca_popular = st.columns(4)
            highlight_promedio.metric("Precio Promedio", f"${self.df['Precio'].mean():,.0f}")
            highlight_kilometraje_promedio.metric("Kilometraje Medio", f"{self.df['Kilometraje'].mean():,.0f} km")
            highlight_vehiculos_filtrados.metric("Vehículos Filtrados", len(self.df))
            marca_popular = self.df['Marca'].mode()[0] if not self.df.empty else "N/A"
            highlight_marca_popular.metric("Marca más Frecuente", marca_popular)

            
            tab1, tab2 = st.tabs(["📊 Análisis Descriptivo", "📈 Dispersión y Densidad"])

            with tab1:
                st.write("##")
                
                grafico_evolucion_de_precios, grafico_distribucion_por_combustible = st.columns([6, 4])
                with grafico_evolucion_de_precios:
                    st.subheader("Evolución de Precios por Año")
                    df_prom = self.df.groupby("Año")["Precio"].mean().reset_index()
                    figura_bar = px.bar(df_prom, x="Año", y="Precio", color_discrete_sequence=['#1f77b4'])
                    st.plotly_chart(figura_bar, use_container_width=True)
                with grafico_distribucion_por_combustible:
                    st.subheader("Distribución por Combustible")
                    figura_pie = px.pie(self.df, names='Tipo de Combustible', hole=0.4)
                    st.plotly_chart(figura_pie, use_container_width=True)
                
                
                st.subheader("Top Marcas por Precio Promedio")
                df_m = self.df.groupby("Marca")["Precio"].mean().sort_values().reset_index()
                figura_h = px.bar(df_m, x="Precio", y="Marca", orientation='h', color="Precio")
                st.plotly_chart(figura_h, use_container_width=True)

            with tab2:
                st.write("##")
                
                columna_precio_vs_condicion, columna_analisis_densidad = st.columns(2)
                with columna_precio_vs_condicion:
                    st.subheader("Precio vs. Condición (Boxplot)")
                    figura_box = px.box(self.df, x="Condición", y="Precio", color="Condición")
                    st.plotly_chart(figura_box, use_container_width=True)
                with columna_analisis_densidad:
                    st.subheader("Análisis de Densidad (Violin)")
                    figura_violin = px.violin(self.df, x="Tipo de Combustible", y="Precio", 
                                         color="Tipo de Combustible", box=True, points="all")
                    st.plotly_chart(figura_violin, use_container_width=True)

                
                st.subheader("Relación Precio vs. Kilometraje (Regresión)")
                figura_scatter = px.scatter(
                    self.df, x="Kilometraje", y="Precio", 
                    color="Condición", opacity=0.5,
                    trendline="ols", 
                    hover_data=['Modelo', 'Año']
                )
                st.plotly_chart(figura_scatter, use_container_width=True)

        elif self.df.empty:
            st.error("⚠️ No hay vehículos que coincidan con esos filtros.")
class Main:
    @staticmethod
    def run():
        st.set_page_config(page_title="Análisis de Carros - UCV", layout="wide")
        app = CarApp('db/precios_carros_arreglado.csv')
        app.cargar_y_limpiar()
        
        
        if app.df_original is not None:
            app.aplicar_filtros()
            app.render_ui()

if __name__ == "__main__":
    Main.run()
