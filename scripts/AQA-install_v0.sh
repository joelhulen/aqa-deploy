#! /bin/bash
CORESITEPATH=/etc/hadoop/conf/core-site.xml
YARNSITEPATH=/etc/hadoop/conf/yarn-site.xml
AMBARICONFIGS_SH=/var/lib/ambari-server/resources/scripts/configs.sh
PORT=8080


SOLLIANCE_TARFILE=solliance.jar


SOLLIANCE_TARFILEURI=https://github.com/joelhulen/aqa-deploy/tree/master/libs/$SOLLIANCE_TARFILE
SOLLIANCE_INSTALLFOLDER=/usr/share/solliance
ACTIVEAMBARIHOST=headnodehost

#import helper module.
wget -O /tmp/HDInsightUtilities-v01.sh -q https://hdiconfigactions.blob.core.windows.net/linuxconfigactionmodulev01/HDInsightUtilities-v01.sh && source /tmp/HDInsightUtilities-v01.sh && rm -f /tmp/HDInsightUtilities-v01.sh

usage() {
    echo ""
    echo "Usage: sudo -E bash aqa-install_v0.sh";
    echo "This script does NOT require Ambari username and password";
    exit 132;
}

checkHostNameAndSetClusterName() {
    fullHostName=$(hostname -f)
    echo "fullHostName=$fullHostName"
    CLUSTERNAME=$(sed -n -e 's/.*\.\(.*\)-ssh.*/\1/p' <<< $fullHostName)
    if [ -z "$CLUSTERNAME" ]; then
        CLUSTERNAME=$(echo -e "import hdinsight_common.ClusterManifestParser as ClusterManifestParser\nprint ClusterManifestParser.parse_local_manifest().deployment.cluster_name" | python)
        if [ $? -ne 0 ]; then
            echo "[ERROR] Cannot determine cluster name. Exiting!"
            exit 133
        fi
    fi
    echo "Cluster Name=$CLUSTERNAME"
}

validateUsernameAndPassword() {
    coreSiteContent=$(bash $AMBARICONFIGS_SH -u $USERID -p $PASSWD get $ACTIVEAMBARIHOST $CLUSTERNAME core-site)
    if [[ $coreSiteContent == *"[ERROR]"* && $coreSiteContent == *"Bad credentials"* ]]; then
        echo "[ERROR] Username and password are invalid. Exiting!"
        exit 134
    fi
}

updateAmbariConfigs() {
    updateResult=$(bash $AMBARICONFIGS_SH -u $USERID -p $PASSWD set $ACTIVEAMBARIHOST $CLUSTERNAME core-site "hadoop.proxyuser.oozie.groups" "*")
    
    if [[ $updateResult != *"Tag:version"* ]] && [[ $updateResult == *"[ERROR]"* ]]; then
        echo "[ERROR] Failed to update core-site. Exiting!"
        echo $updateResult
        exit 135
    fi
    
#    echo "Updated hadoop.proxyuser.a.groups = *"
    
    updateResult=$(bash $AMBARICONFIGS_SH -u $USERID -p $PASSWD set $ACTIVEAMBARIHOST $CLUSTERNAME oozie-site "oozie.service.ProxyUserService.proxyuser.aqa.hosts" "*")
    
    if [[ $updateResult != *"Tag:version"* ]] && [[ $updateResult == *"[ERROR]"* ]]; then
        echo "[ERROR] Failed to update oozie-site. Exiting!"
        echo $updateResult
        exit 135
    fi
    
#    echo "Updated oozie.service.ProxyUserService.proxyuser.aqa.hosts = *"
    
    updateResult=$(bash $AMBARICONFIGS_SH -u $USERID -p $PASSWD set $ACTIVEAMBARIHOST $CLUSTERNAME oozie-site "oozie.service.ProxyUserService.proxyuser.aqa.groups" "*")
    
    if [[ $updateResult != *"Tag:version"* ]] && [[ $updateResult == *"[ERROR]"* ]]; then
        echo "[ERROR] Failed to update oozie-site. Exiting!"
        echo $updateResult
        exit 135
    fi
    
#    echo "Updated oozie.service.ProxyUserService.proxyuser.aqa.hosts = *"
}

stopServiceViaRest() {
    if [ -z "$1" ]; then
        echo "Need service name to stop service"
        exit 136
    fi
    SERVICENAME=$1
    echo "Stopping $SERVICENAME"
    curl -u $USERID:$PASSWD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop Service for AQA installation"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$ACTIVEAMBARIHOST:$PORT/api/v1/clusters/$CLUSTERNAME/services/$SERVICENAME
}

startServiceViaRest() {
    if [ -z "$1" ]; then
        echo "Need service name to start service"
        exit 136
    fi
    sleep 2
    SERVICENAME=$1
    echo "Starting $SERVICENAME"
    startResult=$(curl -u $USERID:$PASSWD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start Service for AQA installation"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$ACTIVEAMBARIHOST:$PORT/api/v1/clusters/$CLUSTERNAME/services/$SERVICENAME)
    if [[ $startResult == *"500 Server Error"* || $startResult == *"internal system exception occurred"* ]]; then
        sleep 60
        echo "Retry starting $SERVICENAME"
        startResult=$(curl -u $USERID:$PASSWD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start Service for AQA installation"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$ACTIVEAMBARIHOST:$PORT/api/v1/clusters/$CLUSTERNAME/services/$SERVICENAME)
    fi
    echo $startResult
}





##############################
if [ "$(id -u)" != "0" ]; then
    echo "[ERROR] The script has to be run as root."
    usage
fi

USERID=$(echo -e "import hdinsight_common.Constants as Constants\nprint Constants.AMBARI_WATCHDOG_USERNAME" | python)

echo "USERID=$USERID"

PASSWD=$(echo -e "import hdinsight_common.ClusterManifestParser as ClusterManifestParser\nimport hdinsight_common.Constants as Constants\nimport base64\nbase64pwd = ClusterManifestParser.parse_local_manifest().ambari_users.usersmap[Constants.AMBARI_WATCHDOG_USERNAME].password\nprint base64.b64decode(base64pwd)" | python)

export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

if [ -e $SOLLIANCE_INSTALLFOLDER ]; then
    echo "AQA is already installed. Exiting ..."
    exit 0
fi

if [[ $OS_VERSION == 14* ]]; then
    export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
elif [[ $OS_VERSION == 16* ]]; then
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
fi

checkHostNameAndSetClusterName
validateUsernameAndPassword
updateAmbariConfigs
stopServiceViaRest HDFS
stopServiceViaRest YARN
stopServiceViaRest MAPREDUCE2
stopServiceViaRest OOZIE

echo "Starting Solliance service"

startServiceViaRest YARN
startServiceViaRest MAPREDUCE2
startServiceViaRest OOZIE
startServiceViaRest HDFS


echo "Solliance service started"
