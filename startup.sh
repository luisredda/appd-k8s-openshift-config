#!/bin/bash

/extractAgent.sh

if [ -z ${ENABLE_SIM} ];
then
    ENABLE_SIM="false"
fi

if [ -z ${ENABLE_SIM_DOCKER} ];
then
    ENABLE_SIM_DOCKER="false"
fi

unzip /tmp/KubernetesSnapshotExtension.zip -d $MACHINE_AGENT_HOME/monitors/ || exit $?
rm /tmp/KubernetesSnapshotExtension.zip

# If the config.yaml and monitor.xml are provided as configMap, make sure they are setup as VolumeMounts in the deployment yaml.

if [ -f /tmp/config.yml ]
then
    cp -f /tmp/config.yml $MACHINE_AGENT_HOME/monitors/KubernetesSnapshotExtension/
fi

if [ -f /tmp/monitor.xml ]
then
        cp -f /tmp/monitor.xml $MACHINE_AGENT_HOME/monitors/KubernetesSnapshotExtension/
fi

MA_PROPERTIES="-Dappdynamics.controller.hostName=${CONTROLLER_HOST}"
MA_PROPERTIES+=" -Dappdynamics.controller.port=${CONTROLLER_PORT}"
MA_PROPERTIES+=" -Dappdynamics.agent.applicationName=${APPLICATION_NAME}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountName=${ACCOUNT_NAME}"
MA_PROPERTIES+=" -Dappdynamics.agent.accountAccessKey=${ACCOUNT_ACCESS_KEY}"
MA_PROPERTIES+=" -Dappdynamics.controller.ssl.enabled=${CONTROLLER_SSL_ENABLED}"
MA_PROPERTIES+=" -Dappdynamics.machine.agent.hierarchyPath=OPENSHIFT-MON-${HOSTNAME}"
MA_PROPERTIES+=" -Dappdynamics.agent.uniqueHostId=k8s-${APPLICATION_NAME}"
MA_PROPERTIES+=" -Dappdynamics.sim.enabled=${ENABLE_SIM}"
MA_PROPERTIES+=" -Dappdynamics.docker.enabled=true"

if [ "x$METRIC_LIMIT" != "x" ]; then
    MA_PROPERTIES+=" -Dappdynamics.agent.maxMetrics=${METRIC_LIMIT}"
fi

# Start Machine Agent
java ${MA_PROPERTIES} -jar ${MACHINE_AGENT_HOME}/machineagent.jar
