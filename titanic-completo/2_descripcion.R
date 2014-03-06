library(ggplot2)
library(reshape2)
library(plyr)
library(stringr)
#require correr el archivo 1_lectura para cargar titanic.completo.
load('titanic.completo.Rdata')
titanic <- titanic.completo

titanic$tripulacion <- rep(0,nrow(titanic))
titanic[which(titanic$Class.Dept %in% c('A la Carte', 'Deck','Engine' ,'Victualling') ),'tripulacion']  <- 1

#pasar edad a numerico
titanic$Age[which(str_detect(titanic$Age,'m') )]  <- as.numeric(substr(x=titanic$Age[which(str_detect(titanic$Age,'m') )] 
                                                                       ,start=1,stop=nchar(titanic$Age[which(str_detect(titanic$Age,'m') )] )-1))/12
titanic$Age <- as.numeric(titanic$Age)

ggplot(data=subset(titanic,Class.Dept!=''), aes(x=Class.Dept,y=Age) ) + 
  geom_point(size=2)+geom_boxplot()

#pasar fare a numerico

x <- str_split( string=titanic$Fare, pattern=' ')
fares <- ldply(.data=x, function(arg){ data.frame(arg[1], arg[2] , arg[3]) }  )
names(fares) <- c('libras','s','d')
fares$libras  <- as.character(fares$libras)
fares$s <- as.character(fares$s)
fares$d <- as.character(fares$d)

fares$libras <- as.numeric( substr(x=fares$libras , start=2,stop=nchar(fares$libras) ) )
fares$s <- as.numeric(substr(x=fares$s, start=1, stop=nchar(fares$s)-1 ) )
fares$d  <- as.numeric(substr(x=fares$d , start=1,stop=nchar(fares$d)-1 ))

fares$libras[is.na(fares$libras)] <- 0
fares$s[is.na(fares$s)] <- 0
fares$d[is.na(fares$d)] <- 0

titanic.1 <- cbind(titanic,fares)


#finalmente

titanic.1[which(titanic.1$Boat==''),'Boat'] <-':( --RIP-- ): '

summary(titanic.1)

#Estadísticas univariadas
summary(titanic.1$Age)
table(titanic.1$Class.Dept)

round(prop.table(table(titanic.1$Class.Dept))*100)
summary(fares)

table(titanic.1$Group)

table(titanic.1$Joined)
round(prop.table(table(titanic.1$Joined))*100)

table(titanic.1$Boat)

hist(titanic$Age)
hist(subset(titanic, libras<20 &tripulacion==0 & Class.Dept!='')$libras)
hist(subset(titanic,tripulacion==0 & Class.Dept!='')$libras)




titanic.limpio <- titanic.1
save(titanic.limpio,file='titanic.limpio.Rdata')

