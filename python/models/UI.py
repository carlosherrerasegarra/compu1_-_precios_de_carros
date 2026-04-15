import streamlit as st
from models.Graphics import Graphics


class UI:

    @staticmethod
    def setup_page():
        st.set_page_config(page_title="Análisis de Carros - UCV", layout="wide")
        st.markdown("""
            <style>
                .block-container { padding-top: 1rem; }
                [data-testid="stMetricValue"] { font-size: 1.8rem; color: #1f77b4; }
            </style>
        """, unsafe_allow_html=True)

    @staticmethod
    def render_sidebar(df_original):
        st.sidebar.header("Filtros de Búsqueda")
        
        marcas = sorted(df_original['Marca'].unique())
        marcas_sel = st.sidebar.multiselect("Selecciona Marcas", marcas, default=marcas)

        año_min, año_max = int(df_original['Año'].min()), int(df_original['Año'].max())
        rango_año = st.sidebar.slider("Rango de Año", año_min, año_max, (año_min, año_max))

        transmisiones = ["Todas"] + list(df_original['Transmisión'].unique())
        trans_sel = st.sidebar.selectbox("Transmisión", transmisiones)

        condiciones = df_original['Condición'].unique()
        cond_sel = st.sidebar.multiselect("Condición", condiciones, default=list(condiciones))

        combustibles = df_original['Tipo de Combustible'].unique()
        comb_sel = st.sidebar.multiselect("Tipo de Combustible", combustibles, default=list(combustibles))

        km_min, km_max = int(df_original['Kilometraje'].min()), int(df_original['Kilometraje'].max())
        rango_km = st.sidebar.slider("Millaje Máximo", km_min, km_max, (km_min, km_max))

        return marcas_sel, rango_año, trans_sel, cond_sel, comb_sel, rango_km

    @staticmethod
    def render_dashboard(df):
        if df.empty:
            st.error("No hay vehículos que coincidan con esos filtros.")
            return

        st.markdown('<div style="text-align: right;"><p style="font-size: 24px; font-weight: bold; margin: 0;">🚗 Dashboard de Precios de Vehículos</p></div>', unsafe_allow_html=True)
        st.markdown("<hr style='margin: 10px 0px 20px 0px; opacity: 0.2;'>", unsafe_allow_html=True)

        highlight_promedio, highlight_millaje_promedio, highlight_vehiculos_filtrados, highlight_marca_popular = st.columns(4)
        
        highlight_promedio.metric("Precio Promedio", f"${df['Precio'].mean():,.0f}")
        highlight_millaje_promedio.metric("Millaje Medio", f"{df['Kilometraje'].mean():,.0f} mi")
        highlight_vehiculos_filtrados.metric("Vehículos Filtrados", len(df))
        marca_popular_val = df['Marca'].mode()[0] if not df.empty else "N/A"
        highlight_marca_popular.metric("Marca más Frecuente", marca_popular_val)

        tab_graficos_descriptivos, tab_graficos_evolucion_y_distribucion, tab_graficos_correlacion_avanzada = st.tabs(
            ["Análisis Descriptivo", "Evolución y Distribución", "Correlación"]
        )

        with tab_graficos_descriptivos:
            st.write("##")
            grafico_evolucion_general, grafico_pie_combustible = st.columns([6, 4])
            
            with grafico_evolucion_general:
                st.subheader("Evolución General de Precios")
                st.plotly_chart(Graphics.bar_evolucion_general(df), use_container_width=True)
            
            with grafico_pie_combustible:
                st.subheader("Cuota de Mercado por Combustible")
                st.plotly_chart(Graphics.pie_combustible(df), use_container_width=True)
            
            st.subheader("Top Marcas por Precio Promedio")
            st.plotly_chart(Graphics.bar_top_marcas(df), use_container_width=True)

        with tab_graficos_evolucion_y_distribucion:
            st.write("##")
            st.subheader("Evolución del Precio Promedio por Marca")
            st.plotly_chart(Graphics.line_evolucion_marca(df), use_container_width=True)

            st.subheader("Distribución de Combustible por Año")
            st.plotly_chart(Graphics.hist_comb_año(df), use_container_width=True)
            
            st.subheader("Distribución de Precios por Marca (Boxplot)")
            st.plotly_chart(Graphics.boxplot_precios(df), use_container_width=True)

        with tab_graficos_correlacion_avanzada:
            st.write("##")
            st.subheader("Matriz de Correlación")
            st.plotly_chart(Graphics.heatmap_correlacion(df), use_container_width=True)

            st.subheader("Relación Precio vs. Millaje (Regresión)")
            st.plotly_chart(Graphics.scatter_millaje_precio(df), use_container_width=True)

