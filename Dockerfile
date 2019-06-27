FROM oracle/glassfish:5.0
COPY helloworld.war $GLASSFISH_HOME/glassfish/domains/domain1/autodeploy/