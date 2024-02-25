#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color
nameserver=$(cat /etc/xray/dns)
clear


# [ membuat repo untuk file slowdns ]
mkdir -p /etc/slowdns

# [ mengambil file yang di perlukan untuk koneksi slowdns ]
cd /etc/slowdns
wget -O server.key "https://raw.githubusercontent.com/fisabiliyusri/SLDNS/main/slowdns/server.key"
wget -O server.pub "https://raw.githubusercontent.com/fisabiliyusri/SLDNS/main/slowdns/server.pub"
wget https://raw.githubusercontent.com/fisabiliyusri/SLDNS/main/slowdns/sldns-client
wget https://raw.githubusercontent.com/fisabiliyusri/SLDNS/main/slowdns/sldns-server

# [ memberikan izin exec pada file ]
chmod +x *
chmod +x /etc/slowdns/*

# [ mengambil service yang di perlukan ]
cat > /etc/systemd/system/client.service <<END
[Unit]
Description=SlowDNS By FN_Project
Documentation=https://prof.rerechan02.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/sldns-client -udp 1.1.1.1:53 --pubkey-file /etc/slowdns/server.pub $nameserver 127.0.0.1:109
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

cat > /etc/systemd/system/server.service <<END
[Unit]
Description=SlowDNS By FN_Project
Documentation=https://t.me/fn_project
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/sldns-server -udp :53 -privkey-file /etc/slowdns/server.key $nameserver 127.0.0.1:443
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

# [ menjalankan service agar dapat digunakan ]
systemctl enable client server
systemctl start client server
clear

echo -e " ${GREEN} Succes install slowdns by Rerechan02 "
sleep 2
clear
