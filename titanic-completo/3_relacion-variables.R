library(ggplot2)

load('titanic.limpio.Rdata')
titanic <- titanic.limpio

ggplot(data=subset(titanic, libras<300 &tripulacion==0 & Class.Dept!='' & Joined!='' & Joined!=' '),
       aes(x=Class.Dept,y=libras, group=Joined, colour=Joined ) ) +geom_point(size=2) + facet_wrap(~Joined) +
  ggtitle('Libras pagadas por Clase y por puerto ')


ggplot(data=subset(titanic, libras<300 &tripulacion==1 & Class.Dept!=''), aes(x=Class.Dept,y=libras) ) +  geom_point(size=2) +  
  ggtitle('Libras pagadas en la tripulación ')


ggplot(data=subset(titanic,   Class.Dept!='' & Joined!='' & Joined!=' '),
       aes(x=Class.Dept,y=Body, group=Joined, colour=Joined ) ) +geom_point(size=2) 


ggplot(data=subset(titanic,   Class.Dept!='' & Joined!='' & Joined!=' '),
       aes(x=Class.Dept,y=Boat, group=Joined, colour=Joined ) ) +geom_point(size=2) + geom_jitter()