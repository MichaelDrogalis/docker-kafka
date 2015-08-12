# Apache Kafka

FROM phusion/baseimage:0.9.17

# Install prerequisites
RUN apt-get update
RUN apt-get install -y software-properties-common

# Install Java 8
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

ENV KAFKA_HOME /opt/kafka

ADD ./src /

RUN chmod +x /usr/local/sbin/start.sh

RUN curl -sS http://mirrors.koehn.com/apache/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz  | tar -xzf - -C /tmp \
  && mv /tmp/kafka_* $KAFKA_HOME \
  && chown -R root:root $KAFKA_HOME

RUN groupadd -r kafka \
  && useradd -c "Kafka" -d /var/lib/kafka -g kafka -M -r -s /sbin/nologin kafka \
  && mkdir /var/lib/kafka && mkdir /var/log/kafka \
  && chown -R kafka:kafka /var/lib/kafka && chown -R kafka:kafka /var/log/kafka

EXPOSE 9092

VOLUME ["/var/lib/kafka"]

ENTRYPOINT ["/usr/local/sbin/start.sh"]
