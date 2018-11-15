FROM tomcat:8.5-jre8
MAINTAINER Sergey Kvyatkovsky
ARG ver
RUN apt-get install wget -y && wget http://192.168.0.45:8081/repository/maven-releases/org/sergeykvyatk/gradleSample/$ver/gradleSample-$ver.war && mv gradleSample-$ver.war /usr/local/tomcat/webapps/gradleSample.war
