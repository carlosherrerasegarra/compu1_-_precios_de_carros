import streamlit.web.cli as stcli
import os, sys

def get_resource_path(relative_path):
    
    try:
        
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)

if __name__ == "__main__":
    #ruta real de Inicio.py dentro del bundle
    inicio_path = get_resource_path("Inicio.py")
    
    sys.argv = [
        "streamlit",
        "run",
        inicio_path,
        "--global.developmentMode=false",
    ]
    sys.exit(stcli.main())