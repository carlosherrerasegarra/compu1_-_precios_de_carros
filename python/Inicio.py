from models.UI import UI
from models.CarApp import CarApp




class Main:

    @staticmethod
    def run():
        UI.setup_page()
        
        app = CarApp('db/precios_carros_arreglado.csv')
        app.cargar_y_limpiar()
        
        if app.df_original is not None:
          
            filtros = UI.render_sidebar(app.df_original)
            
          
            app.aplicar_filtros(*filtros)
            
            
            UI.render_dashboard(app.df)

if __name__ == "__main__":
    Main.run()