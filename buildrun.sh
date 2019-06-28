docker build -t sonia-glassfish .
docker run --rm -ti -p 4848:4848 -p 8080:8080  -v ~/glass/home:/usr/local/glassfish4  sonia-glassfish 
