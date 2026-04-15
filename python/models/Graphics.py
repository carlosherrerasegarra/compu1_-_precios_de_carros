import plotly.express as px



class Graphics:
    
    COLOR_MAP_MARCAS = {
        "Audi": "#F5BD07",
        "BMW": "#0066B2",
        "Ford": "#002C5F",
        "Honda": "#0BA131",
        "Mercedes": "#A6A6A6",
        "Tesla": "#8B0000",
        "Toyota": "#FF4B4B"
    }
    
    COLOR_MAP_COMBUSTIBLE = {
       
        "Diesel": "#F55207",
        "Electrico": "#0066B2",
        "Gasolina": "#FFD500",
        "Hibrido": "#0BA131",
        
    }
    
    COLOR_MAP_TRANSISION = {
        "Automatico": "#575757",
        "Manual": "#0066B2",
    }

    @staticmethod
    def grafico_de_barras_de_combustible_marca(df):
        df_comb_marca = df.groupby(["Marca", "Tipo de Combustible"]).size().reset_index(name='count')
        grafico = px.bar(
            df_comb_marca, x="Marca", y="count", color="Tipo de Combustible", 
            color_discrete_map=Graphics.COLOR_MAP_COMBUSTIBLE,
            labels={'count': 'Número de Vehículos', 'Marca': 'Marca'}
        )
        grafico.update_layout(barmode='stack', showlegend=True)
        return grafico

    @staticmethod
    def grafico_de_barras_de_evolucion_general(df):
        df_prom = df.groupby("Año")["Precio"].mean().reset_index()
        grafico = px.bar(df_prom, x="Año", y="Precio", color_discrete_sequence=['#1f77b4'])
        grafico.update_layout(yaxis_tickprefix='$', yaxis_tickformat=',.0f')
        grafico.update_traces(hovertemplate="Año: %{x}<br>Precio Promedio: $%{y:,.0f}")
        return grafico

    @staticmethod
    def grafico_de_torta_de_combustible(df):
        grafico = px.pie(
            df, 
            names='Tipo de Combustible', 
            hole=0.4, 
            color='Tipo de Combustible',
            color_discrete_map=Graphics.COLOR_MAP_COMBUSTIBLE
        )
        grafico.update_traces(hovertemplate="%{label}<br>Vehículos: %{value}<br>Porcentaje: %{percent}")
        return grafico

    @staticmethod
    def grafico_de_barras_de_top_marcas(df):
        df_m = df.groupby("Marca")["Precio"].mean().sort_values().reset_index()
       
        grafico = px.bar(
            df_m, x="Precio", y="Marca", orientation='h', 
            color="Marca", color_discrete_map=Graphics.COLOR_MAP_MARCAS
        )
        grafico.update_layout(
            xaxis_tickprefix='$', 
            xaxis_tickformat=',.0f',
            showlegend=False, 
            coloraxis_showscale=False
        )
        grafico.update_traces(hovertemplate="Marca: %{y}<br>Precio Promedio: $%{x:,.0f}")
        return grafico
    
    @staticmethod
    def historigrama_de_precio(df):
        return px.histogram(df, x="Precio", nbins=30, )

    @staticmethod
    def line_evolucion_marca(df):
        df_evo_marca = df.groupby(["Año", "Marca"])["Precio"].mean().reset_index()
        grafico = px.line(
            df_evo_marca, x="Año", y="Precio", color="Marca", 
            markers=True, color_discrete_map=Graphics.COLOR_MAP_MARCAS,
           
        )
        grafico.update_layout(
            yaxis_tickprefix='$', 
            yaxis_tickformat=',.0f',
            showlegend=False
        )
        return grafico

    @staticmethod
    def historigrama_de_comb_año(df):
        return px.histogram(
            df, 
            x="Año", 
            color="Tipo de Combustible", 
            barmode="stack",
            color_discrete_map=Graphics.COLOR_MAP_COMBUSTIBLE
             )
        
    @staticmethod
    def boxplot_transmision(df):
        grafico = px.box(
            df, x="Transmisión", y="Precio", color="Transmisión",
            points="all", notched=True, labels={'Precio': 'Precio ($)'},
            color_discrete_map=Graphics.COLOR_MAP_TRANSISION
        )
        grafico.update_layout(
            yaxis_tickprefix='$', 
            yaxis_tickformat=',.0f',
            showlegend=False
        )
        return grafico

    @staticmethod
    def boxplot_combustible(df):
        grafico = px.box(
            df, x="Tipo de Combustible", y="Precio", color="Tipo de Combustible",
            points="all", notched=True, labels={'Precio': 'Precio ($)'},
            color_discrete_map=Graphics.COLOR_MAP_COMBUSTIBLE
        )
        grafico.update_layout(
            yaxis_tickprefix='$', 
            yaxis_tickformat=',.0f',
            showlegend=False
        )
        return grafico
    @staticmethod
    def line_evolucion_millaje(df):
        df_evo_millaje = df.groupby(["Año", "Marca"])["Kilometraje"].mean().reset_index()
        grafico = px.line(
            df_evo_millaje, x="Año", y="Kilometraje", color="Marca", 
            markers=True, color_discrete_map=Graphics.COLOR_MAP_MARCAS,
            labels={'Kilometraje': 'Millaje (mi)', 'Año': 'Año'}
        )
        grafico.update_layout(
            yaxis_tickprefix='', 
            yaxis_tickformat=',.0f',
            showlegend=False
        )
        return grafico

    @staticmethod
    def boxplot_precios(df):
        grafico = px.box(
            df, x="Marca", y="Precio", color="Marca",
            points="all", notched=True, labels={'Precio': 'Precio ($)'},
            color_discrete_map=Graphics.COLOR_MAP_MARCAS
        )
        grafico.update_layout(
            yaxis_tickprefix='$', 
            yaxis_tickformat=',.0f',
            showlegend=False
        )
        return grafico

    @staticmethod
    def heatmap_correlacion(df):
        orden_variables = ['Tamaño del Motor', 'Año', 'Kilometraje', 'Precio']
        df_corr = df[orden_variables].corr()
        grafico = px.imshow(
            df_corr, text_auto=".2f", color_continuous_scale='RdBu_r', 
            x=orden_variables, y=orden_variables
        )
        grafico.update_layout(coloraxis_showscale=False)
        return grafico

    @staticmethod
    def scatter_millaje_precio(df):
        grafico = px.scatter(
            df, x="Kilometraje", y="Precio", color="Condición", opacity=0.5, 
            trendline="ols", labels={'Kilometraje': 'Millaje (mi)', 'Precio': 'Precio ($)'}
        )
        grafico.update_traces(line=dict(color="red"), selector=dict(mode="lines"))
        grafico.update_layout(
            yaxis_tickprefix='$', 
            yaxis_tickformat=',.0f',
            showlegend=False,
            coloraxis_showscale=False
        )
        grafico.update_traces(hovertemplate="Millaje: %{x:,.0f} mi<br>Precio: $%{y:,.0f}", selector=dict(mode="markers"))
        return grafico