FROM centos
RUN mkdir /opt/tomcat/
WORKDIR /opt/tomcat/
RUN yum install java -y 
RUN https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz
RUN tar -xvzf apache-tomcat-9.0.78.tar.gz
RUN mv apache-tomcat-9.0.78/* /opt/tomcat
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/centos-*
RUN sed -i 's'
CMD /bin/bash
EXPOSE 8080
CMD ["/OPT/TOMCAT/BIN/STARTUP.SH"]


