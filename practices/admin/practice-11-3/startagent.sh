source setgrinderenv.sh
java -Dcom.sun.net.ssl.checkRevocation=false -classpath $CLASSPATH net.grinder.Grinder $GRINDERPROPS
