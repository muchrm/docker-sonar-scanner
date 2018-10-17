FROM alpine:3.8

ENV TZ=Asia/Bangkok
RUN apk --no-cache add \
		tzdata \
	&& cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
	&& apk del tzdata

#install node docker
RUN apk add --no-cache openjdk8-jre nodejs nodejs-npm docker

ENV SONAR_VERSION 3.2.0.1227
ENV HOST=http://localhost:9000
ENV PROJECTKEY=test
ENV LOGIN=some-token
ENV SONAR_RUNNER_HOME=/root/sonar-scanner-$SONAR_VERSION-linux
ENV PATH=$PATH:$SONAR_RUNNER_HOME/bin

WORKDIR /root
#install sonar
RUN apk add --no-cache  --virtual .build-deps-sonar curl grep sed unzip \
  && curl --insecure -o ./sonarscanner.zip -L \
  https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_VERSION-linux.zip \
  && unzip sonarscanner.zip \
  && rm -f sonarscanner.zip\
  && sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONAR_RUNNER_HOME/bin/sonar-scanner \
  && apk del .build-deps-sonar

WORKDIR /root/project
CMD sonar-scanner \
  -Dproject.settings=sonar-project.properties \
  -Dsonar.host.url=$HOST \
  -Dsonar.login=$LOGIN
