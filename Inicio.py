# main.py
import streamlit as st
import pandas as pd
from components.Column_Chart import column_chart

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
        """Dibuja la interfaz de Streamlit."""
        st.title("🚗 Análisis del precio de carros")
        
        if self.df is not None:
            st.write("### Vista General de los Datos")
            st.dataframe(
                self.df, 
                use_container_width=True,
                column_config={"Car ID": None}
            )
        else:
            st.warning("No hay datos cargados para mostrar.")


class Main:
    @staticmethod
    def run():
        # 1. Instanciar la lógica de la app
        app = CarApp('./db/data.csv')
        
        # 2. Ejecutar procesos iniciales
        app.cargar_y_limpiar()
        
        # 3. Lanzar la interfaz
        app.render_ui()
        
        
# Punto de entrada estándar de Python
if __name__ == "__main__":
    Main.run()        
        


