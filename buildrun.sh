docker build -t sonia-glassfish .
docker run --rm -ti -p 4848:4848 -p 8080:8080 -p 8181:8181 -v glassfish:/usr/local/glassfish4  sonia-glassfish 
