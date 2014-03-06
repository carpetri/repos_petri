library(shiny)
library(ggplot2)
library(Hmisc)
library(reshape2)
library(arm)
library(plyr)
library(gbm)
library(knitr)
library(xtable)
load('mod.boost.Rdata')
load('dat.6.RData')

dat.x <- log(1+dat.6[,c('peatonal.s1.num','peatonal.s2.num','vehicular.s1.num',
                        'vehicular.s2.num','competencia.directa.total','metros2','generadores.totales')])
cov.inv <- solve(var(dat.x, na.rm=TRUE))
medias.log <- apply(dat.x,2, mean, na.rm=T)

outlier.val <- function(x, limite=15){
  ##limite debe ser 150
  ## orden es'peatonal.s1.num','peatonal.s2.num','vehicular.s1.num',
  #'vehicular.s2.num','competencia.directa.total','metros2','generadores.totales'
  t(log(1+x)-medias.log)%*%cov.inv%*%(log(1+x)-medias.log) > limite
}

shinyServer(function(input, output) {
  
  dato<- reactive(function(){
    #input  
    peatonal.s1.num <- as.numeric(input$peatonal.s1.num)
    peatonal.s2.num  <- as.numeric(input$peatonal.s2.num)
    vehicular.s1.num <- as.numeric(input$vehicular.s1.num)
    vehicular.s2.num <- as.numeric(input$vehicular.s2.num)
    poblacion<- as.numeric(input$poblacion)  
    generadores.totales<- as.numeric(input$generadores.totales)
    ubicacion <- as.character(input$ubicacion)
    tipo.de.calle <- as.character(input$tipo.de.calle)
    pdm.media.anual <- as.numeric(input$pdm.media.anual)
    X24hrs <- input$X24hrs
    competencia.directa.total <- as.numeric(input$competencia.directa.total)
    cajas <- as.character(input$cajas)
   
    metros2 <-  as.numeric(input$metros2)
   
    #salud [-0.5976,-0.0651) [-0.0651, 0.0729) [ 0.0729, 0.2955]
    
    mediasalud <- 4.172733
    log.p.serv.salud.c  <-  log(input$SALUD1_R) - mediasalud

           
    #indicebienestar  [-0.4889,-0.0884) [-0.0884, 0.0764) [ 0.0764, 0.3689]
    
      
    x <- log( (input$VIV2_R +input$VIV27_R +input$VIV28_R +input$VIV33_R +input$VIV35_R +input$VIV36_R)) - 6.008364
    
    bienestar.tercil <- ifelse(x <=-0.0884,'Bajo',ifelse(x<0.0764,'Medio','Alto' ))
      
    #dato
    
    dato <- as.data.frame( cbind(peatonal.s1.num,peatonal.s2.num,
                                vehicular.s1.num,vehicular.s2.num,tipo.de.calle,ubicacion,
                                X24hrs,competencia.directa.total,cajas,
                                bienestar.tercil, log.p.serv.salud.c,metros2,
                                 pdm.media.anual, poblacion,generadores.totales  ) )
    dato$peatonal.s1.num <- as.numeric(as.character(dato$peatonal.s1.num))
    dato$peatonal.s2.num <- as.numeric(as.character(dato$peatonal.s2.num))
    dato$vehicular.s1.num <- as.numeric(as.character(dato$vehicular.s1.num))
    dato$vehicular.s2.num <- as.numeric(as.character(dato$vehicular.s2.num))
    dato$log.p.serv.salud.c  <- as.numeric(as.character(dato$log.p.serv.salud.c))
    dato$competencia.directa.total <- as.numeric(as.character(dato$competencia.directa.total))
    dato$metros2  <- as.numeric(as.character(dato$metros2))
    dato$pdm.media.anual <- as.numeric(as.character(dato$pdm.media.anual))
    dato$poblacion <- as.numeric(as.character(dato$poblacion ))  
    dato$generadores.totales  <- as.numeric(as.character(dato$generadores.totales ))
    dato$ubicacion <- factor(as.character(dato$ubicacion), levels=c('Esquina','Media Calle','Tipo T') )
    dato$tipo.de.calle <- factor(as.character(dato$tipo.de.calle), levels=c("", "Mixta", "Peatonal", "Vehicular") )
    dato$X24hrs <- factor(as.character(dato$X24hrs), levels=c("", "no", "si") )
    dato$cajas <- factor(as.character(dato$cajas), levels=c('1 a 2 ','3 o mas ') )
    dato$bienestar.tercil <- factor(as.character(dato$bienestar.tercil), levels=c('Bajo','Medio','Alto') )
    
    dato
    })
    
    inter <- reactive(function(){
    dat <- dat.6
    dat.1 <- subset(dat, select= c(prom.ventas,peatonal.s1.num,peatonal.s2.num,vehicular.s1.num,vehicular.s2.num,
                                   competencia.directa.total, metros2,pdm.media.anual , poblacion,generadores.totales) )
    dat.1 <-na.omit(dat.1) 
    variable=names(dat.1)
    izq=NULL
    der=NULL
    mediana=NULL    
    i <- 1
    izq[i]=quantile(  subset(dat.6,X24hrs=='si' & cajas=='3 o mas ')$prom.ventas,    na.rm=T, probs=.1)
    der[i]=quantile(  subset(dat.6,X24hrs=='si'& cajas=='3 o mas ' )$prom.ventas,    na.rm=T, probs=.9)
    mediana[i]=quantile(  subset(dat.6,X24hrs=='si' & cajas=='3 o mas ')$prom.ventas,    na.rm=T, probs=.5)
        
    for(i in 2:ncol(dat.1))
    {
      izq[i]=quantile( dat.1[,i],    na.rm=T, probs=.1)
      der[i]=quantile(  dat.1[,i],   na.rm=T, probs=.9)
      mediana[i]=quantile(  dat.1[,i],   na.rm=T, probs=.5)
    }
    inter <- data.frame(variable, mediana, izq, der)
    inter 
  })
    
  output$data  <-  renderPrint({
    pred <- predict(mod.boost,newdata=dato(),se.fit=T, n.trees=680)[1]
    pred.1 <- exp(pred)
    x <-round(pred.1/(30*1000), digits=2)
    print( paste('Promedio de ventas (diarias) miles:',x) )
    ## orden es'peatonal.s1.num','peatonal.s2.num','vehicular.s1.num',
    #'vehicular.s2.num','competencia.directa.total','metros2','generadores.totales'
    out.val <- as.numeric(dato()[1,c('peatonal.s1.num','peatonal.s2.num','vehicular.s1.num','vehicular.s2.num','competencia.directa.total','metros2','generadores.totales')])
    print(paste('Atípico' ,outlier.val(out.val) ))
  })
  
  output$plot <-renderPlot({
      

      inter.1 <- subset(inter(), variable %in% c('peatonal.s1.num', 'peatonal.s2.num', 
                                             'vehicular.s1.num','vehicular.s2.num','metros2', 
                                             'competencia.directa.total', 'generadores.totales', 'poblacion') ) 
      
      dato.1 <- data.frame(names(dato()), t(dato()) )
      names(dato.1) <- c('variable','valor')
      
      dato.2 <- subset(dato.1, variable %in% c('peatonal.s1.num', 'peatonal.s2.num', 
                                               'vehicular.s1.num','vehicular.s2.num','metros2',
                                               'competencia.directa.total', 'generadores.totales', 'poblacion') )
      dat.2 <- join(inter.1,dato.2) 
      
      dat.2$valor <- as.numeric(as.character(dat.2$valor))
      
      
      print(plot.1 <- 
        ggplot(dat.2, aes(x=variable, y=valor/mediana ,colour=variable, ymin= (izq)/mediana , ymax=(der)/mediana , label=as.character(valor)))+
           geom_linerange(size=4, alpha=.7)+geom_point(size=6,color='grey' )+  xlab('')+ylab('')+ geom_text(colour='black') +
          theme(axis.text.x=element_text(size=25),axis.text.y=element_text(size=25), legend.position='none' )+
          scale_x_discrete(breaks=sort(c('peatonal.s1.num', 'peatonal.s2.num', 
                                         'vehicular.s1.num','vehicular.s2.num','metros2',
                                         'competencia.directa.total', 'generadores.totales', 'poblacion')),
                           labels=c('Competencia Directa', ' Generadores Totales', 'Metros cuadrados', 'Flujo Peatonal - S1', 'Flujo Peatonal - S2',
                                    'Población', 'Flujo Vehicular - S1', 'Flujo Vehicular - S2')) +       coord_flip()
      )
               save(plot.1, file='plot_1.Rd')

  })
    
  output$plot2  <-  renderPlot({

      inter.1 <- subset(inter(), variable %in% c('prom.ventas') ) 
      prom.ventas <- exp(predict(mod.boost,newdata=dato())) /30
      up <-  prom.ventas*(1+.28) 
      lb <-  prom.ventas*(1-.28) 
      
      print(plot.2 <- qplot(x='Promedio Ventas',y=prom.ventas,ymin=lb,ymax=up ,
                  label=as.character(round(prom.ventas))  ) + 
               ylim(min(dat.6$prom.ventas/30),max(dat.6$prom.ventas)/30 )+
               xlab('')+ylab('')+
               geom_linerange(size=2,color='grey')+
               geom_hline(yintercept=input$corte, size=2,alpha=.8)+
               geom_point(size=10,color='grey', alpha=.7 ) +    geom_text(colour='black') +
               
               theme(axis.text.x=element_text(size=20),axis.text.y=element_text(size=20), legend.position='none' )+ coord_flip() 
      )
           save(plot.2, file='plot_2.Rd')

    })

    output$reporte = downloadHandler(
    filename = 'myreport.pdf',
    
    content = function(file) {
      out = knit2pdf('input_reporte.Rnw', clean = TRUE)
      file.rename(out, file) # move pdf to file for downloading
    },
    
    contentType = 'application/pdf'
  )
  
})
