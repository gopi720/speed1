FROM ubuntu:22.04
RUN apt update -y && apt install -y openjdk-11-jdk
ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.115/bin/apache-tomcat-9.0.115.tar.gz .
RUN tar -xvzf apache-tomcat-9.0.115.tar.gz
COPY target/speed.war apache-tomcat-9.0.115/webapps/
CMD ["apache-tomcat-9.0.115/bin/catalina.sh", "run"]