#FROM openjdk:8-jdk-slim # This image should work as well
FROM 632713433352.dkr.ecr.us-west-2.amazonaws.com/java8_base:oracle-jdk8

COPY KubernetesSnapshotExtension-0.72.zip /tmp/KubernetesSnapshotExtension.zip
COPY config.yml /tmp/config.yml
COPY startup.sh /startup.sh
COPY extractAgent.sh /extractAgent.sh

RUN chmod +x /startup.sh
RUN chmod +x /extractAgent.sh

CMD "/startup.sh"
