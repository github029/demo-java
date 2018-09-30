FROM tomcat:8.5
MAINTAINER veerendra <gkveerendra@gmail.com>
# Place the code version inside the webapps directory

ARG PACKAGE_VERSION

RUN echo "${PACKAGE_VERSION}" >> /usr/local/tomcat/webapps/version.txt

# Debugging tools: A few ways to handle debugging tools.
# Trade off is a slightly more complex volume mount vs keeping the image size down.
RUN apt-get update && \
  apt-get install -y \
    net-tools \
    tree \
    vim && \
  rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get purge

RUN echo "export JAVA_OPTS=\"-Dapp.env=staging\"" > /usr/local/tomcat/bin/setenv.sh

COPY pkg/demo.war /usr/local/tomcat/webapps/demo.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
