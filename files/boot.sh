#!/bin/bash

CONFIG_DIR=/etc/openhab/

#Modify Configs according to Docker Environment Variables
sed -e "s/\$SUPERVISORED_PORT/$SUPERVISORED_PORT/g" -e "s/\$OPENHAB_IP/$OPENHAB_IP/g" /etc/supervisor/supervisord.variables-conf > /etc/supervisor/supervisord.conf; \
sed -e "s/\$OPENHAB_IP/$OPENHAB_IP/g" -e "s/\$OPENHAB_HTTP_PORT/$OPENHAB_HTTP_PORT/g" -e "s/\$OPENHAB_HTTPS_PORT/$OPENHAB_HTTPS_PORT/g" -e "s/\$OPENHAB_TELNET_PORT/$OPENHAB_TELNET_PORT/g" /etc/supervisor/conf.d/openhab.variables-conf > /etc/supervisor/conf.d/openhab.conf; \
sed -e "s/\$OPENHAB_IP/$OPENHAB_IP/g" -e "s/\$OPENHAB_HTTP_PORT/$OPENHAB_HTTP_PORT/g" -e "s/\$OPENHAB_HTTPS_PORT/$OPENHAB_HTTPS_PORT/g" -e "s/\$OPENHAB_TELNET_PORT/$OPENHAB_TELNET_PORT/g" /etc/supervisor/conf.d/openhab_debug.variables-conf > /etc/supervisor/conf.d/openhab_debug.conf;

####################
# Configure timezone

TIMEZONEFILE=$CONFIG_DIR/timezone

if [ -f "$TIMEZONEFILE" ]
then
  cp $TIMEZONEFILE /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
fi

###########################
# Configure Addon libraries

SOURCE=/opt/openhab/addons-available
DEST=/opt/openhab/addons
ADDONFILE=$CONFIG_DIR/addons.cfg

function addons {
  # Remove all links first
  rm $DEST/*

  # create new links based on input file
  while read STRING
  do
    STRING=${STRING%$'\r'}
    echo Processing $STRING...
    if [ -f $SOURCE/$STRING-$OPENHAB_VERSION.jar ]
    then
      ln -s $SOURCE/$STRING-$OPENHAB_VERSION.jar $DEST/
      echo link created.
    else 
      if [ -f $SOURCE/$STRING-*.jar ]
      then
        ln -s $SOURCE/$STRING-*.jar $DEST/
        echo link created.
      fi
      echo not found.
    fi
  done < "$ADDONFILE"
}

if [ -f "$ADDONFILE" ]
then
  addons
else
  echo addons.cfg not found.
fi

###########################################
# Download Demo if no configuration is given

if [ -f $CONFIG_DIR/openhab.cfg ]
then
  echo configuration found.
  rm -rf /tmp/demo-openhab*
else
  echo --------------------------------------------------------
  echo          NO openhab.cfg CONFIGURATION FOUND
  echo
  echo                = using demo files =
  echo
  echo Consider running the Docker with a openhab configuration
  echo 
  echo --------------------------------------------------------
  cp -R /opt/openhab/demo-configuration/configurations/* /etc/openhab/
  ln -s /opt/openhab/demo-configuration/addons/* /opt/openhab/addons/
  ln -s /etc/openhab/openhab_default.cfg /etc/openhab/openhab.cfg
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
