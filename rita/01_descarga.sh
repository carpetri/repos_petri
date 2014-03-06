  #!/bin/bash
  
[-d rita.urls] && rm rita.urls
  
for year in {1987..2008}
do
  echo "http://stat-computing.org/dataexpo/2009/$year.csv.bz2" >> rita.urls
done
  
echo "http://stat-computing.org/dataexpo/2009/airports.csv" >> rita.urls
echo "http://stat-computing.org/dataexpo/2009/carriers.csv" >> rita.urls
echo "http://stat-computing.org/dataexpo/2009/plane-data.csv" >> rita.urls

# Descargamos en paralelo
cat rita.urls | parallel curl -O 
