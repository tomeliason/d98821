# specify additional JMX java command line options for servers
if [ "${SERVER_NAME}" = "JCS_doma_adminserver" ] ; then
        JAVA_OPTIONS="${JAVA_OPTIONS} -Djava.rmi.server.hostname=localhost -Dcom.sun.management.jmxremote.rmi.port=6666 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=6666 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
fi 
if [ "${SERVER_NAME}" = "JCS_doma_server_1" ] ; then
        JAVA_OPTIONS="${JAVA_OPTIONS} -Djava.rmi.server.hostname=localhost -Dcom.sun.management.jmxremote.rmi.port=6667 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=6667 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
fi
if [ "${SERVER_NAME}" = "JCS_doma_server_2" ] ; then
        JAVA_OPTIONS="${JAVA_OPTIONS} -Djava.rmi.server.hostname=localhost -Dcom.sun.management.jmxremote.rmi.port=6667 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=6667 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
fi
if [ "${SERVER_NAME}" = "JCS_doma_server_3_DG" ] ; then
        JAVA_OPTIONS="${JAVA_OPTIONS} -Djava.rmi.server.hostname=localhost -Dcom.sun.management.jmxremote.rmi.port=6666 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=6666 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
fi
if [ "${SERVER_NAME}" = "JCS_doma_server_4_DG" ] ; then
        JAVA_OPTIONS="${JAVA_OPTIONS} -Djava.rmi.server.hostname=localhost -Dcom.sun.management.jmxremote.rmi.port=6667 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=6667 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
fi
