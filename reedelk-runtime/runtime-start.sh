#!/bin/bash

# Find the current script directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

CLASSPATH="${DIR}/bin/runtime.jar:${DIR}lib/*"
COMMONS_JAVA_ARGS="-Dio.netty.allocator.type=unpooled $@"

version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1-2 | tr -d .)

# Number check
re='^[0-9]+$'
if ! [[ $version =~ $re ]] ; then
    # The version could not be recognized. We start the runtime with default parameters.
   java -cp $CLASSPATH $COMMONS_JAVA_ARGS com.reedelk.runtime.Launcher
fi

# Java < 1.8 not supported
if [ $version -lt "18" ]; then
  echo "Reedelk runtime could not start. Java 1.8 or higher is required."
elif [ $version -gt "18" ]; then
	java -cp $CLASSPATH $COMMONS_JAVA_ARGS --add-opens java.base/java.net=ALL-UNNAMED --add-opens java.base/sun.net.www.protocol.file=ALL-UNNAMED --add-opens java.base/sun.net.www.protocol.ftp=ALL-UNNAMED --add-opens java.base/sun.net.www.protocol.http=ALL-UNNAMED --add-opens java.base/sun.net.www.protocol.https=ALL-UNNAMED --add-opens java.base/sun.net.www.protocol.jar=ALL-UNNAMED com.reedelk.runtime.Launcher
else
	java -cp $CLASSPATH $COMMONS_JAVA_ARGS com.reedelk.runtime.Launcher
fi