#!/usr/bin/with-contenv bash

# Create CUPS data directories for persistence
mkdir -p /data/cups/cache
mkdir -p /data/cups/logs
mkdir -p /data/cups/state
mkdir -p /data/cups/config

# Set proper permissions
chown -R root:lp /data/cups
chmod -R 775 /data/cups

# Create CUPS configuration directory if it doesn't exist
mkdir -p /etc/cups

# Basic CUPS configuration without admin authentication
cat > /data/cups/config/cupsd.conf << EOL
# Listen on all interfaces
Listen 0.0.0.0:631

# Allow access from local network
<Location />
  Order allow,deny
	Allow print.local.svey.xyz
  Allow localhost
  Allow 10.0.0.0/8
  Allow 10.50.0.0/16
	Allow 10.11.0.0/16
	Allow 10.10.0.0/16
</Location>

# Admin access (no authentication)
<Location /admin>
  Order allow,deny
	Allow print.local.svey.xyz
  Allow localhost
  Allow 10.0.0.0/8
  Allow 10.50.0.0/16
	Allow 10.11.0.0/16
	Allow 10.10.0.0/16
</Location>

# Job management permissions
<Location /jobs>
  Order allow,deny
	Allow print.local.svey.xyz
  Allow localhost
  Allow 10.0.0.0/8
  Allow 10.50.0.0/16
	Allow 10.11.0.0/16
	Allow 10.10.0.0/16
</Location>

<Limit Send-Document Send-URI Hold-Job Release-Job Restart-Job Purge-Jobs Set-Job-Attributes Create-Job-Subscription Renew-Subscription Cancel-Subscription Get-Notifications Reprocess-Job Cancel-Current-Job Suspend-Current-Job Resume-Job Cancel-My-Jobs Close-Job CUPS-Move-Job CUPS-Get-Document>
  Order allow,deny
	Allow print.local.svey.xyz
  Allow localhost
  Allow 10.0.0.0/8
  Allow 10.50.0.0/16
	Allow 10.11.0.0/16
	Allow 10.10.0.0/16
</Limit>

# Enable web interface
WebInterface Yes

# Default settings
DefaultAuthType None
JobSheets none,none
PreserveJobHistory No
EOL

# Create a symlink from the default config location to our persistent location
ln -sf /data/cups/config/cupsd.conf /etc/cups/cupsd.conf
ln -sf /data/cups/config/printers.conf /etc/cups/printers.conf

# Start CUPS service
/usr/sbin/cupsd -f