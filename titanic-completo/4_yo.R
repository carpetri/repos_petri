library(ggplot2)
#crecimiento del PIB
load('titanic.limpio.Rdata')
crec.pib <-read.table(file='pib-uk.csv', header=TRUE, sep=",", dec=".", 
                        as.is=TRUE, comment.char="#",quote="\"")
qplot(x=crec.pib$ano,y=crec.pib$pib.cte.2005.us)+geom_line()+ geom_smooth()

library(Hmisc)
#formula para pasar a dlls de 2012 1 dollar = .6 poud
(crec.pib[2012-1919+1,]/ crec.pib[1,])
titanic.limpio$pesos <- titanic.limpio$libras *13* .6*(crec.pib[2012-1919+1,2]/ crec.pib[1,2])
titanic.limpio$q.pesos <- cut2(titanic.limpio$pesos,g=10 )
titanic <- titanic.limpio
ggplot(data=subset(titanic, libras<300 &tripulacion==0 & Class.Dept!='' & Joined!='' & Joined!=' '),
       aes(x=Class.Dept,y=pesos, group=Joined, colour=Joined ) ) +geom_point(size=2) + facet_wrap(~Joined) +
  ggtitle('Libras pagadas por Clase y por puerto ')

ggplot(data=subset(titanic,   Class.Dept!='' & Joined!='' & Joined!=' '),
       aes(x=Class.Dept,y=Boat, group=q.pesos, colour=q.pesos ) ) +geom_point(size=2) + geom_jitter()

