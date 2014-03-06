library(shiny)
library(ggplot2)
library(Hmisc)
library(reshape2)
library(arm)
library(plyr)

shinyUI(
  
  pageWithSidebar(
  
  # Application title
  headerPanel(
  list(HTML('<img src="LogoITAM.png" style="width: 20%; height: 20%" />'), "Modelo predictivo para puntos"
    ),
  windowTitle="Modelo predictivo Farmacias del Ahorro"
  ),
  

  sidebarPanel(

    h3("Flujos peatonales y vehiculares"),
    numericInput("peatonal.s1.num", 
                "Flujo Peatonal Sentido 1:", 
                min = 20,
                max = 1000, 
                value = 300)
    ,
    numericInput("peatonal.s2.num", 
                "Flujo Peatonal Sentido 2:", 
                min = 1,
                max = 570, 
                value = 120) 
    ,
    numericInput("vehicular.s1.num", 
                "Flujo Vehicular Sentido 1:", 
                min = 200,
                max = 2200, 
                value = 1000) 
    ,
    numericInput("vehicular.s2.num", 
                "Flujo Vehicular Sentido 2:", 
                min = 1,
                max = 1000, 
                value = 300) 
    
    ,
    
    h3("Ubicación y tipo de calle"),
    
    selectInput(inputId="tipo.de.calle",label="Tipo de calle",
                list("Peatonal" = "Peatonal", 
                     "Mixta" = "Mixta", 
                     "Vehicular" = "Vehicular"), selected='Vehicular')
    ,
    selectInput("ubicacion", "Ubicación de la sucursal",
                list("Esquina" = "Esquina", 
                     "Media Calle" = "Media Calle", 
                     "Tipo T" = "Tipo T"), selected='Esquina')
    ,

    numericInput("poblacion", 
                "Población Total zona influencia", 
                min = 14000,
                max = 66500, 
                value = 20000),

    h3("Tamaño de sucursal y costo"),
    numericInput("metros2", "Metros cuadrados",
                min =50,
                max =700, 
                value =150 )
    
    ,


    h3("Características del AGEB (Variables del INEGI)")
    ,
    numericInput("VIV2_R", "Porcentaje de viviendas particulares habitadas",
                value= 80)
    ,
    numericInput("VIV27_R", "Porcentaje de viviendas particulares habitadas con lavadora",
                 value= 80)
    ,
    numericInput("VIV28_R", "Porcentaje de viviendas particulares habitadas con automóvil",
                 value= 80)
    ,
    numericInput("VIV33_R", "Porcentaje de viviendas particulares habitadas con computadora",
                 value= 80)
    ,
    numericInput("VIV35_R", "Porcentaje de viviendas particulares habitadas con celular",
                 value= 80)
    ,
    numericInput("VIV36_R", "Porcentaje de viviendas particulares habitadas con internet",
                 value= 80)
    ,
    numericInput("SALUD1_R", "Porcentaje de población con acceso a salud",
                 value= 80)

,
    h3("Participación de mercado, Generadores y Competencia"),
        sliderInput("pdm.media.anual", 
                "Participación de mercado de FA (anual) ", 
                min = 0,
                max = 60, 
                value = 15)
    ,
    numericInput("generadores.totales", 
                "Generadores totales", 
                min = 20,
                max = 175, 
                value = 60)
    ,
    numericInput("competencia.directa.total",'Competencia directa', min=0 , max=100, value= 15),

    #tableOutput("data")
      h3("Variables operativas"),
    
    selectInput("X24hrs", "Abre 24 horas",
                list("No" = 'no',"Si" = 'si'), selected='Si')
    ,
    selectInput("cajas", "Número de cajas en la sucursal",
                list("Una a dos" = '1 a 2 ', 
                     "Tres o más" = '3 o mas '), selected='Tres o más')
    
  
    
    
  


  
)#slider
    ,
        
  mainPanel(
    

    h3('Predicción'),
    h2(as.character(verbatimTextOutput("data"))),
    numericInput("corte", 
                 "Corte de ventas diarias por plaza operativa", 
                 min = 20,
                 max = 1000, 
                 value = 53400),
    plotOutput("plot2", width = "100%", height = "120px"),
    h3('Rangos para variables'),
    plotOutput("plot", width = "100%", height = "300px")
    ,
    br(),
    img(src = "LogoITAM.png",style="width: 50%; height: 50%"),
    br(),
    br(),
    p("Creado por:",
      a("@carpetri", 
        href = "https://github.com/carpetri")),
    downloadButton('reporte','Reporte')

    

)))