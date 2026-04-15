import plotly.express as px



class Graphics:
    
    COLOR_MAP = {
        "Audi": "#F5BD07",
        "BMW": "#0066B2",
        "Ford": "#002C5F",
        "Honda": "#0BA131",
        "Mercedes": "#A6A6A6",
        "Tesla": "#8B0000",
        "Toyota": "#FF4B4B"
    }

    @staticmethod
    def bar_evolucion_general(df):
        df_prom = df.groupby("Año")["Precio"].mean().reset_index()
        fig = px.bar(df_prom, x="Año", y="Precio", color_discrete_sequence=['#1f77b4'])
        fig.update_layout(yaxis_tickprefix='$', yaxis_tickformat=',.0f')
        fig.update_traces(hovertemplate="Año: %{x}<br>Precio Promedio: $%{y:,.0f}")
        return fig

    @staticmethod
    def pie_combustible(df):
        fig = px.pie(df, names='Tipo de Combustible', hole=0.4)
        fig.update_traces(hovertemplate="%{label}<br>Vehículos: %{value}<br>Porcentaje: %{percent}")
        return fig

    @staticmethod
    def bar_top_marcas(df):
        df_m = df.groupby("Marca")["Precio"].mean().sort_values().reset_index()
       
        fig = px.bar(
            df_m, x="Precio", y="Marca", orientation='h', 
            color="Marca", color_discrete_map=Graphics.COLOR_MAP
        )
        fig.update_layout(
            xaxis_tickprefix='$', 
            xaxis_tickformat=',.0f',
            showlegend=False, 
            coloraxis_showscale=False
        )
        fig.update_traces(hovertemplate="Marca: %{y}<br>Precio Promedio: $%{x:,.0f}")
        return fig

    @staticmethod
    def line_evolucion_marca(df):
        df_evo_marca = df.groupby(["Año", "Marca"])["Precio"].mean().reset_index()
        fig = px.line(
            df_evo_marca, x="Año", y="Precio", color="Marca", 
            markers=True, color_discrete_map=Graphics.COLOR_MAP
        )
        fig.update_layout(
            yaxis_tickprefix='$', 
            yaxis_tickformat=',.0f',
            showlegend=False
        )
        return fig

    @staticmethod
    def hist_comb_año(df):
        return px.histogram(df, x="Año", color="Tipo de Combustible", barmode="stack")

    @staticmethod
    def boxplot_precios(df):
        fig = px.box(
            df, x="Marca", y="Precio", color="Marca",
            points="all", notched=True, labels={'Precio': 'Precio ($)'},
            color_discrete_map=Graphics.COLOR_MAP
        )
        fig.update_layout(
            yaxis_tickprefix='$', 
            yaxis_tickformat=',.0f',
            showlegend=False
        )
        return fig

    @staticmethod
    def heatmap_correlacion(df):
        orden_variables = ['Tamaño del Motor', 'Año', 'Kilometraje', 'Precio']
        df_corr = df[orden_variables].corr()
        fig = px.imshow(
            df_corr, text_auto=".2f", color_continuous_scale='RdBu_r', 
            x=orden_variables, y=orden_variables
        )
        fig.update_layout(coloraxis_showscale=False)
        return fig

    @staticmethod
    def scatter_millaje_precio(df):
        fig = px.scatter(
            df, x="Kilometraje", y="Precio", color="Condición", opacity=0.5, 
            trendline="ols", labels={'Kilometraje': 'Millaje (mi)', 'Precio': 'Precio ($)'}
        )
        fig.update_traces(line=dict(color="red"), selector=dict(mode="lines"))
        fig.update_layout(
            yaxis_tickprefix='$', 
            yaxis_tickformat=',.0f',
            showlegend=False,
            coloraxis_showscale=False
        )
        fig.update_traces(hovertemplate="Millaje: %{x:,.0f} mi<br>Precio: $%{y:,.0f}", selector=dict(mode="markers"))
        return fig