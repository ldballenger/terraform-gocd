# Use this file to configure your GoCD agent
# See the `wrapper-properties.conf.example` file for the configuration syntax

# setup the GoCD server URL
wrapper.app.parameter.100=-serverUrl
wrapper.app.parameter.101=https://${go-server_priv_ip}:8154/go

# This is an example configuration file to override any GoCD configuration.

# For a detailed description about setting various environment variables, see the page at
# https://wrapper.tanukisoftware.com/doc/english/props-envvars.html

# For a detailed description about setting JVM options and system properties, see the page at
# https://wrapper.tanukisoftware.com/doc/english/props-jvm.html

# To use a custom JVM:
# wrapper.java.command=/path/to/java

# To set any environment variables of your choice use the following syntax
#set.SOME_ENVIRONMENT_VARIABLE=some-value
#set.GRADLE_HOME=/path/to/gradle
#set.M2_HOME=C:\apache-maven-3.2.1
#set.MAVEN_OPTS=-Xmx1048m -Xms256m -XX:MaxPermSize=312M

set.AGENT_WORK_DIR=/var/lib/$${SERVICE_NAME:-go-agent}

# Appending to existing environment variables:
# This config supports environment variable expansion at run time within the values of any environment variable.
# To maintain the platform independent nature of this configuration file, the Windows syntax is used for all platforms.

# On windows:
#set.PATH=..\lib;%PATH%

# On Unix/Linux/macOS. Note that you must use %PATH%, and not $PATH, as you'd normally do on this platform
#set.PATH=../lib:%PATH%

# Set any system properties. We recommend that you begin with the index `100` and increment the index for each system property
#wrapper.java.additional.100=-Dcom.example.enabled=true
#wrapper.java.additional.101=-Dcom.example.name=bob

# If a property contains quotes, these can be stripped out, but this works only on Unix/Linux/macOS
#wrapper.java.additional.103=-Dmyapp.data="../MyApp Home"
#wrapper.java.additional.104.stripquotes=TRUE

# Set a memory limit of 8GB (usually needed on your GoCD server for large setups). We recommend that you do not use more than half your system memory.
#wrapper.java.additional.105=-Xmx8G