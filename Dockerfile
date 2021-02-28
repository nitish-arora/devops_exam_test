FROM tomcat:alpine
MAINTAINER nitish
ADD http://localhost:8086/artifactory/try/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war /usr/local/tomcat/webapps/devopssampleapplication.war
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run