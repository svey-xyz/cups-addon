#!/usr/bin/with-contenv bash

# Create CUPS configuration directory if it doesn't exist
mkdir -p /etc/cups

# Basic CUPS configuration
cat > /etc/cups/cupsd.conf << EOL
# Listen on all interfaces
Listen 0.0.0.0:631

# Allow access from local network
<Location />
  Order allow,deny
  Allow localhost
  Allow 10.0.0.0/8
  Allow 172.16.0.0/12
  Allow 192.168.0.0/16
</Location>

# Admin access
<Location /admin>
  AuthType Basic
  Require user ${CUPS_ADMIN_USERNAME:-printadmin}
  Order allow,deny
  Allow localhost
  Allow 10.0.0.0/8
  Allow 172.16.0.0/12
  Allow 192.168.0.0/16
</Location>

# Enable web interface
WebInterface Yes

# Default settings
DefaultAuthType Basic
JobSheets none,none
PreserveJobHistory No
EOL

# Set admin password if provided
if [ -n "${CUPS_ADMIN_PASSWORD}" ]; then
    echo "${CUPS_ADMIN_USERNAME:-printadmin}:${CUPS_ADMIN_PASSWORD}" | chpasswd
fi

# Start CUPS service
rc-service cupsd start