library(bigmemory)
library(biganalytics)
library(bigtabulate)
library(biglm)

if( require(multicore) ) {
  library(doMC)
  registerDoMC()
} else {
  warning("Considera registrar un procesador para el foreach")
}

nom <- c('Year','Month','DayofMonth','DayOfWeek','DepTime','CRSDepTime','ArrTime','CRSArrTime','FlightNum','ActualElapsedTime','CRSElapsedTime','AirTime','ArrDelay','DepDelay','Distance','TaxiIn','TaxiOut','Cancelled','CancellationCode','Diverted','CarrierDelay','WeatherDelay','NASDelay','SecurityDelay','LateAircraftDelay', 'TailNum', 'Origin', 'Destiny', 'Carrier')
backing.file <- "rita.bin"
descriptor.file <- "rita.desc"
system.time(rita <- read.big.matrix("rita.psv",type="integer",backingfile=backing.file, 
                                    descriptorfile=descriptor.file, header=FALSE,col.names = nom, 
                                    extraCols = ('edad.avion','dist.prom')))
system.time(rita <- attach.big.matrix("rita.desc"))

rita[rita[,15] == 0,15] <- NA
tabla <- bigtabulate(rita,ccols = "TailNum", summary.cols = "Distance",summary.na.rm = TRUE)
stat.names <- dimnames(tabla$summary[[1]])[2][[1]]
tabla.1 <- cbind(matrix(unlist(tabla$summary), byrow = TRUE,nrow = length(tabla$summary),
      ncol = length(stat.names),dimnames = list(dimnames(tabla$table)[[1]], stat.names)),ValidObs = tabla$table)
distancias <- data.frame(tabla.1[,3])
row.names(distancias) <- dimnames(tabla$table)[[1]]
names(distancias) <- 'dist.prom'

year <- as.numeric(format(Sys.Date(), '%Y'))*365.25
month <- as.numeric(format(Sys.Date(), '%m'))*30
day <- as.numeric(format(Sys.Date(), '%d'))
today <- year + month + day

rita[rita[,1] == 0,1] <- NA
rita[rita[,2] == 0,2] <- NA
rita[rita[,3] == 0,3] <- NA
rita[,30] <- NA
rita[,30] <- round((today-(rita[,3] + rita[,2]* 30 + rita[,1] * 365.25))/365.25, 2)
tabla <- bigtabulate(rita,ccols = "TailNum", summary.cols = "edad.avion", summary.na.rm = TRUE)
tabla.1 <- cbind(matrix(unlist(tabla$summary), byrow = TRUE, nrow = length(tabla$summary),
                    ncol = length(stat.names),dimnames = list(dimnames(tabla$table)[[1]], stat.names)),
                      ValidObs = tabla$table)
edad.avion <- data.frame(tabla.1[,2])
row.names(edad.avion) <- dimnames(tabla$table)[[1]]
names(edad.avion) <- 'edad.avion'
res <- cbind(edad.avion, distancias)
write.table(res, 'distancia.edad.csv', row.names = TRUE, col.names = TRUE, sep = ',')

