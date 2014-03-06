library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
archivo <- args[1]
planes <- read.table('aviones.psv', sep = '|', colClasses = rep('character', 2))
data <- read.table(archivo,  sep = ',', header = FALSE,colClasses = rep('character', 29))
names(planes) <- c('NumTail', 'TailNum')

data$TailNum <- toupper(data$V11)
data <- dplyr:::left_join(data, planes, type = 'left', by = 'TailNum')
data$TailNum <- NULL
data$V11 <- NULL
data.fix <- data[is.na(data$NumTail),]
data <- data[!is.na(data$NumTail),]
nom.fix <- paste(archivo,'fix', sep='_')
nom <- paste(archivo,'join', sep='_')

write.table(data.fix, file = nom.fix, sep = '|', col.names = FALSE)
write.table(data, file = nom, sep = '|', col.names = FALSE)