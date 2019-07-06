FROM        openjdk:8

ENV         JAVA_HOME         /usr/lib/jvm/java-8-openjdk-amd64
ENV         GLASSFISH_HOME    /usr/local/glassfish4
ENV         PATH              $PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin
ENV         PASSWORD  glassfish2

RUN         apt-get update && \
            apt-get install -y curl unzip zip inotify-tools && \
            rm -rf /var/lib/apt/lists/*

RUN         curl -L -o /tmp/glassfish-4.1.zip http://download.java.net/glassfish/4.1/release/glassfish-4.1.zip && \
            unzip /tmp/glassfish-4.1.zip -d /usr/local && \
            rm -f /tmp/glassfish-4.1.zip

RUN mkdir /internalCerts
# keytool -genkey -v -alias myalias -keyalg RSA -storetype PKCS12 -keystore /certfiles/client_keystore.p12 -storepass mypassword -keypass mypassword
COPY client_keystore.p12 /internalCerts/client_keystore.p12
RUN keytool -export -alias myalias -keystore /internalCerts/client_keystore.p12 -storetype PKCS12 -storepass mypassword -rfc -file /internalCerts/selfsigned.cer
RUN keytool -import -trustcacerts -v -noprompt -file /internalCerts/selfsigned.cer -keystore /usr/local/glassfish4/glassfish/domains/domain1/config/cacerts.jks -alias myalias -storepass changeit 

COPY     sample.war /usr/local/glassfish4/glassfish/domains/domain1/autodeploy/sample.war


RUN echo "--- Setup the password file ---" && \
    echo "AS_ADMIN_PASSWORD=" > /tmp/glassfishpwd && \
    echo "AS_ADMIN_NEWPASSWORD=${PASSWORD}" >> /tmp/glassfishpwd  && \
    echo "--- Enable DAS, change admin password, and secure admin access ---" && \
    asadmin --user=admin --passwordfile=/tmp/glassfishpwd change-admin-password --domain_name domain1 && \
    asadmin start-domain && \
    echo "AS_ADMIN_PASSWORD=${PASSWORD}" > /tmp/glassfishpwd && \
    asadmin --user=admin --passwordfile=/tmp/glassfishpwd enable-secure-admin && \
    asadmin --user=admin stop-domain && \
    rm /tmp/glassfishpwd





EXPOSE      8080 4848 8181

WORKDIR     /usr/local/glassfish4

# verbose causes the process to remain in the foreground so that docker can track it
CMD         asadmin start-domain --verbose

#docker run -d -ti -p 4848:4848 -p 8080:8080 -p 8181:8181  soniab/glassfish
