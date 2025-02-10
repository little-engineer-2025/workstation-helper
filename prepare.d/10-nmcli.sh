# Configure NetworkManager

CONN_NAME="e760b99c-999c-3143-9dbc-f321ea211f09"

nmcli con modify "${CONN_NAME}" connection.autoconnect 1
nmcli con modify "${CONN_NAME}" ipv4.dns 127.0.0.53
nmcli con modify "${CONN_NAME}" ipv4.ignore-auto-dns 1
