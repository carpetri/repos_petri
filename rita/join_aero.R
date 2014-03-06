library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
archivo <- args[1]
aeros <- read.table('aeropuertos.psv', sep = '|',colClasses = c('character','character') )
data <- read.table(archivo, sep = ',', header = FALSE, colClasses = rep('character', 29 ) )
data$V1 <- NULL
names(aeros) <- c('Index', 'Origin')
data$Origin <- toupper(data$V17)
data <- dplyr:::left_join(data, aeros, type = 'left', by = 'Origin')
data$Origin <- NULL
data$V17 <- NULL

data$Origin <- toupper(data$V18)
data <- dplyr:::left_join(data, aeros, type = 'left', by = 'Origin')
data$Origin <- NULL
data$V18 <- NULL

nombre<- paste(archivo,'join', sep='_')
write.table(data, file = nombre, sep = ',', col.names = FALSE, row.names = FALSE)