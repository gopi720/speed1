FROM ubuntu:20.04
ENV JAVA_HOME=/u01/middleware/jdk-11
ENV TOMCAT_HOME=/u01/middleware/apache-tomcat-9.0.62
RUN PATH=$PATH:$JAVA_HOME/bin:$TOMCAT_HOME/bin
RUN mkdir -p /u01/middleware
WORKDIR /u01/middleware
ADD https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz .
ADD https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.22/bin/apache-tomcat-10.0.22.tar.gz .
RUN tar -xzvf openjdk-11+28_linux-x64_bin.tar.gz 
RUN tar -xzvf apache-tomcat-10.0.22.tar.gz
