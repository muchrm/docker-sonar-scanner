FROM openjdk:8-alpine

RUN apk add --no-cache  curl grep sed unzip

ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /root

RUN curl --insecure -o ./sonarscanner.zip -L https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-linux.zip

RUN unzip sonarscanner.zip
RUN rm sonarscanner.zip

ENV SONAR_RUNNER_HOME=/root/sonar-scanner-3.0.3.778-linux
ENV PATH $PATH:/root/sonar-scanner-3.0.3.778-linux/bin
#   ensure Sonar uses the provided Java for musl instead of a borked glibc one
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /root/sonar-scanner-3.0.3.778-linux/bin/sonar-scanner

ENV HOST=http://sonarqube:9000
ENV PROJECTKEY=mis-backend
ENV LOGIN=cbeb49149a2f2ce1b5272129d402e5b63903973e

WORKDIR /root/project
CMD sonar-scanner \
  -Dproject.settings=sonar-project.properties \
  -Dsonar.host.url=$HOST \
  -Dsonar.login=$LOGIN
