# Apache Kafka

FROM anapsix/alpine-java
MAINTAINER Michael Drogalis <michael.drogalis@onyxplatform.org>

ENV KAFKA_HOME /opt/kafka

ADD ./src /

RUN chmod +x /usr/local/sbin/start.sh

RUN curl -sS http://mirrors.koehn.com/apache/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz  | tar -xzf - -C /tmp \
  && mv /tmp/kafka_* $KAFKA_HOME \
  && chown -R root:root $KAFKA_HOME

RUN addgroup -S kafka \
  && adduser -h /var/lib/kafka -G kafka -H -S -s /sbin/nologin kafka \
  && mkdir /var/lib/kafka && mkdir /var/log/kafka \
  && chown -R kafka:kafka /var/lib/kafka && chown -R kafka:kafka /var/log/kafka

EXPOSE 9092

VOLUME ["/var/lib/kafka"]

ENTRYPOINT ["/usr/local/sbin/start.sh"]
