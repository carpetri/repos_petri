library(dplyr)
args <- commandArgs(trailingOnly = TRUE)
archivo <- args[1]
carriers <- read.table('aerolineas.psv', sep = '|',  colClasses = rep('character', 2))
data <- read.table(archivo,sep = '|', header = FALSE,colClasses = rep('character', 29))
names(carriers) <- c('Index', 'carriers')
data$carriers <- toupper(data$V9)
data <- dplyr:::left_join(data, carriers, type = 'left', by = 'Carriers')
data$carriers <- NULL
data$V9 <- NULL
nom <- paste(archivo,'join', sep='_')
write.table(data, file = nom, sep = '|', col.names = FALSE, row.names = FALSE)