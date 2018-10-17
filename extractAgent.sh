#!/bin/sh

if [ -d "/sharedFiles" ]; then
    echo "/sharedFiles found!"

  if [ -f "/sharedFiles/MachineAgent.zip" ]; then
      echo "/sharedFiles/MachineAgent.zip found!"

      MACHINE_AGENT_HOME=/appdynamics/machine-agent
      mkdir -p ${MACHINE_AGENT_HOME}
      cp /sharedFiles/MachineAgent.zip /appdynamics/MachineAgent.zip
      unzip -oq /appdynamics/MachineAgent.zip -d ${MACHINE_AGENT_HOME} && rm /appdynamics/MachineAgent.zip

      mv /tmp/ServerMonitoring.yml ${MACHINE_AGENT_HOME}/extensions/ServerMonitoring/conf
      mv /tmp/analytics-agent.properties ${MACHINE_AGENT_HOME}/monitors/analytics-agent/conf/analytics-agent.properties
      mv /tmp/monitor.xml ${MACHINE_AGENT_HOME}/monitors/analytics-agent/monitor.xml

  else

    echo "/sharedFiles/MachineAgent.zip not found!"

  fi

else

  echo "/sharedFiles not found!"
