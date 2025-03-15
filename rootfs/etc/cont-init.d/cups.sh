#!/usr/bin/with-contenv bash

# Create CUPS configuration directory if it doesn’t exist
mkdir -p /etc/cups

# Basic CUPS configuration without admin authentication
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

# Admin access (no authentication)
<Location /admin>
  Order allow,deny
  Allow localhost
  Allow 10.0.0.0/8
  Allow 172.16.0.0/12
  Allow 192.168.0.0/16
</Location>

# Enable web interface
WebInterface Yes

# Default settings
DefaultAuthType None
JobSheets none,none
PreserveJobHistory No
EOL

# Start CUPS service
/usr/sbin/cupsd -f