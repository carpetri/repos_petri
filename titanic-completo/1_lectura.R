#####CARLOS PETRICIOLI TAREA3
lista.datos <- lapply( dir('../../../lecture_3/data/', pattern="csv"),function(archivo){print(archivo)
 read.table(file=paste('../../../lecture_3/data/',archivo,sep=''), header=TRUE, sep="|", dec=".", 
                         as.is=TRUE, comment.char="#",quote="\"")  })

#hay que quitar la base sobre la gente que no se subió
discharged.crew <- lista.datos[[2]]
lista.datos[[2]] <- NULL

#hay que quitar la base sobre titanic 3
titanic.3 <- lista.datos[[10]]
lista.datos[[10]] <- NULL

#limpio columnas adicionales
for(i in 1:length(lista.datos)) { 
  lista.datos[[i]] <- lista.datos[[i]][,1:11] 
  print(names(lista.datos[[i]])) }

titanic.completo <- Reduce(function(x,y) {rbind(x,y)}, lista.datos)
save(titanic.completo,file='titanic.completo.Rdata')
write.table(titanic.completo,file='titanic-complete.psv',sep='|' )

