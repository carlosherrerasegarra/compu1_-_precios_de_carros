# 🚗 Dashboard de Análisis del Mercado Automotriz

Este proyecto es una herramienta de **Análisis Exploratorio de Datos (EDA)** desarrollada para la asignatura de Computación I de la **Escuela de Estadística y Ciencias Actuariales (EECA - UCV)**. El sistema procesa y visualiza tendencias de mercado de 2,500 vehículos (modelos 2000-2024).

## 📊 Alcance Estadístico
El dashboard permite realizar un estudio multidimensional basado en:
- **Estadística Descriptiva:** Cálculo automático de media, mediana y moda para precios y kilometraje.
- **Análisis de Dispersión:** Identificación de variabilidad y detección de *outliers* mediante diagramas de caja.
- **Análisis Bivariante:** Correlación entre el uso (kilometraje) y el valor de mercado.
- **Análisis Multivariante:** Matrices de correlación para entender la influencia del año y el motor en el precio.

## 🛠️ Tecnologías y Librerías
* **Python 3.x**: Lenguaje principal.
* **Streamlit**: Framework para la interfaz web interactiva.
* **Pandas**: Limpieza, transformación y manipulación de estructuras de datos (DataFrames).
* **Plotly Express**: Generación de gráficos dinámicos e interactivos.
* **Statsmodels**: Motor estadístico para el cálculo de líneas de tendencia y regresiones.

## 🚀 Instalación y Uso

1. **Clonar el repositorio o descargar los archivos.**
2. **Instalar las dependencias necesarias:**
   ```bash
   pip install streamlit pandas plotly statsmodels