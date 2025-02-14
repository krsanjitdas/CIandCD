FROM tomcat:9.0-jdk11
#LABEL maintainer="your-email@example.com"
# Remove the default webapps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the WAR file to Tomcat's webapps directory
COPY target/CIandCD.war /usr/local/tomcat/webapps/app.war
# Expose port 8080 for the Tomcat container
EXPOSE 8090
# Start Tomcat
CMD ["catalina.sh", "run"]

#FROM openjdk:11
#EXPOSE 8080
#ADD target/CIandCD.war CIandCD.war
#ENTRYPOINT ["java","-jar","/CIandCD.war"]
