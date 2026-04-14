# Usamos una imagen ligera de Python
FROM python:3.9-slim

# Directorio de trabajo
WORKDIR /app

# Copiamos los archivos de tu proyecto
COPY . .

# Instalamos las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Hugging Face Spaces usa el puerto 7860 por defecto
EXPOSE 7860

# Comando para ejecutar Streamlit apuntando al puerto de HF
CMD ["streamlit", "run", "Inicio.py", "--server.port=7860", "--server.address=0.0.0.0"]