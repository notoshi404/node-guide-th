# Bitcoin node for Raspberry Pi

คู่มือนี้จะใช้ Bitcoin Core ติดตั้งคุณสามารถตรวจสอบเวอร์ชั่นล่าสุดได้ที่ https://bitcoincore.org/en/download/



## อัปเดตระบบและติดตั้งเครื่องมือพื้นฐาน

หลังจากที่ติดตั้ง OS เรียบร้อยแล้ว มาเตรียมความพร้อมก่อนลงโหนด

อัปเดตระบบ

```bash
sudo apt update && sudo apt upgrade -y
```

ติดตั้งเครื่องมือพื้นฐาน

```bash
sudo apt install wget curl gnupg tar ufw -y
```



## ตั้งค่า Firewall

เปิด Port เท่าที่จำเป็นต้องใช้

```bash
sudo ufw allow 22/tcp comment 'ssh'
```

```bash
sudo ufw allow 9051/tcp comment 'tor'
```

```bash
sudo ufw allow 9050/tcp comment 'tor'
```

```bash
sudo ufw allow 8333/tcp comment 'Bitcoin core peer'
```

```bash
sudo ufw allow 8332/tcp comment 'Bitcoin core RPC'
```

เปิด Firewall

```bash
sudo ufw enable
```

ตรวจสอบ Port Firewall

```bash
sudo ufw status
```



### วิธีจัดการ Firewall

หากต้องการเปิด Port ใช้คำสั่งนี้

```bash
sudo ufw allow xx comment 'xx'
```

ตรวจสอบ Port Firewall ว่าเราเปิดใช้อะไรบ้าง

```bash
sudo ufw status
```

หากต้องการการลบ Port ที่ไม่ต้องการใช้ควรเริ่มตามนี้
ดูหมายเลข Port ก่อน

```bash
sudo ufw status numbered
```

แล้วลบตามหมายเลข เช่น:

```bash
sudo ufw delete 3
```



## ติดตั้งและตั้งค่า Tor สำหรับ Bitcoin RPC

ติดตั้ง tor

```bash
sudo apt install tor -y
```

แก้ไข Tor configuration

```bash
sudo nano /etc/tor/torrc
```

เพิ่มค่า Tor configuration

```
# ControlPort & Authentication
ControlPort 9051
CookieAuthentication 1
CookieAuthFileGroupReadable 1

# Bitcoin RPC
HiddenServiceDir /var/lib/tor/bitcoin/bitcoinrpc
HiddenServiceVersion 3
HiddenServicePort 8332 127.0.0.1:8332
HiddenServiceEnableIntroDoSDefense 1
```

สร้าง Directory สำหรับ Hidden Service

```bash
sudo mkdir -p /var/lib/tor/bitcoin/bitcoinrpc
```

เปลี่ยน Ownership และ Permissions ของ Directory

```bash
sudo chown -R debian-tor:debian-tor /var/lib/tor/bitcoin/bitcoinrpc
```

```bash
sudo chmod 700 /var/lib/tor/bitcoin/bitcoinrpc
```

เพิ่ม User ให้กับ Group debian-tor

```bash
sudo usermod -a -G debian-tor username
```

> [!NOTE]
> อย่าลืมเปลี่ยน USERNAME ให้ตรงกับ user ของคุณ

restart tor

```bash
sudo systemctl restart tor
```



## ดาวน์โหลดและตรวจสอบ Bitcoin Core

ตั้งค่า version environment สำหรับติดตั้ง

```sh
VERSION=30.0
```

ดาวน์โหลด Bitcoin core ลงเครื่อง

```bash
wget https://bitcoincore.org/bin/bitcoin-core-$VERSION/bitcoin-$VERSION-aarch64-linux-gnu.tar.gz
```

> [github](https://github.com/bitcoin/bitcoin/)

ดาวน์โหลด signatures ล่าสุด

```bash
wget https://bitcoincore.org/bin/bitcoin-core-$VERSION/SHA256SUMS
```

```bash
wget https://bitcoincore.org/bin/bitcoin-core-$VERSION/SHA256SUMS.asc
```



### นำเข้าคีย์ของผู้พัฒนาและตรวจสอบลายเซ็น

นำเข้าคีย์ของผู้พัฒนา

```bash
curl -s "https://api.github.com/repositories/355107265/contents/builder-keys" | grep download_url | grep -oE "https://[a-zA-Z0-9./-]+" | while read url; do curl -s "$url" | gpg --import; done
```
output
```
gpg: key 17565732E08E5E41: 29 signatures not checked due to missing keys
gpg: /home/admin/.gnupg/trustdb.gpg: trustdb created
gpg: key 17565732E08E5E41: public key "Andrew Chow <andrew@achow101.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg: no ultimately trusted keys found
[...]
```

ตรวจสอบ Signature

```bash
gpg --verify SHA256SUMS.asc SHA256SUMS
```
output
```
gpg: Good signature from...
Primary key fingerprint:...
```

ตรวจสอบซอฟต์แวร์ว่าถูกต้องไหม

```bash
sha256sum --ignore-missing --check SHA256SUMS
```
output
```
bitcoin-30.0-aarch64-linux-gnu.tar.gz: OK
```



## ติดตั้ง Bitcoin Core

แตกไฟล์ Bitcoin core

```bash
tar -xzvf bitcoin-$VERSION-aarch64-linux-gnu.tar.gz
```

ติดตั้ง Bitcoin core

```bash
sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-30.0/bin/bitcoin-cli bitcoin-30.0/bin/bitcoind
```

ตรวจสอบเวอร์ชั่น

```bash
bitcoind --version
```

ทดสอบ Bitcoin core โดยสั่งให้ทำงาน

```bash
bitcoind -daemon
```

ตรวจสอบไฟล์ log 

```bash
tail -f ~/.bitcoin/debug.log
```

ตรวจสอบการซิงค์ของ Bitcoin core

```bash
bitcoin-cli getblockchaininfo
```

ตรวจสอบการเชื่อมต่อ Peers

```bash
bitcoin-cli getconnectioncount
```

ตรวจสอบ Bitcoin core เขื่อมต่อกับ network ไหนบ้าง

```bash
bitcoin-cli -netinfo
```

สั่ง Bitcoin core หยุดทำงาน

```bash
bitcoin-cli stop
```

ลบไฟล์ติดตั้งที่ไม่ใช้แล้ว

```bash
sudo rm -r bitcoin-$VERSION bitcoin-$VERSION-aarch64-linux-gnu.tar.gz SHA256SUMS SHA256SUMS.asc
```



### ตั้งค่า bitcoin.conf

ตัวไฟล์คอนฟิกจะตั้งค่าไว้ให้ใช้ Tor อย่างเดียวเพื่อเชื่อมต่อ peer อาจทำให้ซิงค์ช้าลง

สร้างไฟล์ bitcoin.conf

```bash
nano ~/.bitcoin/bitcoin.conf
```

ตัวอย่างไฟล์ bitcoin.conf

```
# Bitcoin Core
daemon=1
txindex=1

# RPC
server=1
rpcport=8332
rpcbind=0.0.0.0
rpcallowip=127.0.0.1
rpcallowip=10.0.0.0/8
rpcallowip=172.0.0.0/8
rpcallowip=192.0.0.0/8

# Network (Tor-only)
listen=1
onlynet=onion
onion=127.0.0.1:9050
proxy=127.0.0.1:9050
bind=127.0.0.1

# Network option
#onlynet=ipv4
#onlynet=ipv6


# Performance
dbcache=2048
```

> [!NOTE]
> คุณสามารถตั้งค่า bitcoin.conf ด้วยตัวเองได้ที่
> https://jlopp.github.io/bitcoin-core-config-generator




### สร้างไฟล์ system service

การสร้าง System Service เพื่อให้ระบบสามารถเรียกใช้ bitcoin daemon โดยอัตโนมัติในพื้นหลังได้หลังปิด-เปิดเครื่อง

```bash
sudo nano /etc/systemd/system/bitcoind.service
```

configuration

```
[Unit]
Description=Bitcoin daemon
After=network.target

[Service]
ExecStart=/usr/local/bin/bitcoind -daemon \
                                  -pid=/run/bitcoind/bitcoind.pid \
                                  -conf=/home/username/.bitcoin/bitcoin.conf \
                                  -datadir=/home/username/.bitcoin 

ExecStop=/usr/local/bin/bitcoin-cli stop

# Make sure the config directory is readable by the service user
PermissionsStartOnly=true

# Process management
####################
Type=forking
Restart=on-failure
TimeoutStartSec=infinity
TimeoutStopSec=600


# Directory creation and permissions
####################################

User=uesermane
Group=uesermane

# /run/bitcoind
RuntimeDirectory=bitcoind
RuntimeDirectoryMode=0710

# /etc/bitcoin
ConfigurationDirectory=bitcoin
ConfigurationDirectoryMode=0710

# /var/lib/bitcoind
StateDirectory=bitcoind
StateDirectoryMode=0710

# Hardening measures
####################

# Provide a private /tmp and /var/tmp.
PrivateTmp=true

# Mount /usr, /boot/ and /etc read-only for the process.
ProtectSystem=full

# Disallow the process and all of its children to gain
# new privileges through execve().
NoNewPrivileges=true

# Use a new /dev namespace only populated with API pseudo devices
# such as /dev/null, /dev/zero and /dev/random.
PrivateDevices=true

# Deny the creation of writable and executable memory mappings.
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target
```

> [!NOTE]
> อย่าลืมเปลี่ยน USERNAME ให้ตรงกับ user ของคุณ
> แหล่งอ้างอิง https://raw.githubusercontent.com/bitcoin/bitcoin/663f6cd9ddadeec30b27ec12f0f5ed49f3146cc9/contrib/init/bitcoind.service

เปิดใช้งาน Bitcoind

```bash
sudo systemctl enable bitcoind
```

```bash
sudo systemctl start bitcoind
```

ตรวจสอบว่า Bitcoind ทำงานไหม

```bash
sudo systemctl status bitcoind
```
output
```
$ sudo systemctl status bitcoind
● bitcoind.service - Bitcoin daemon
     Loaded: loaded (/etc/systemd/system/bitcoind.service; enabled; preset: enabled)
     Active: active (running) since Sat 2025-04-19 14:10:16 UTC; 23min ago
    Process: 812 ExecStart=/usr/local/bin/bitcoind -daemon -conf=/home/node/.bitcoin/bitcoin.conf -datadir=/home/node/.bitcoin (code=exited, >
   Main PID: 876 (bitcoind)
      Tasks: 26 (limit: 4552)
     Memory: 3.2G (peak: 3.2G swap: 252.0K swap peak: 252.0K)
        CPU: 12min 55.480s
     CGroup: /system.slice/bitcoind.service
             └─876 /usr/local/bin/bitcoind -daemon -conf=/home/node/.bitcoin/bitcoin.conf -datadir=/home/node/.bitcoin

Apr 19 14:10:14 node systemd[1]: Starting bitcoind.service - Bitcoin daemon...
Apr 19 14:10:16 node bitcoind[812]: Bitcoin Core starting
Apr 19 14:10:16 node systemd[1]: Started bitcoind.service - Bitcoin daemon.
```


### ทุกครั้งเมื่อมีการแก้ไขไฟล์ bitcoin.conf ควร restart bitcoind.service ทุกครั้ง

ใช้คำสั่ง restart

```bash
sudo systemctl restart bitcoind
```
หลังจาก restart เสร็จควรตรวจสอบสถานะทุกครั้ง

```bash
sudo systemctl status bitcoind
```



## ตัวเลือกในการซิงค์บล็อกให้พร้อมใช้เร็วขึ้นโดยใช้ UTXO Snapshot

หลังจากการซิงค์ blockheaders ถึง block ปัจจุบันแล้วเราจะนำเข้า UTXO snapshot

ตรวจสอบ blockheaders

```bash
bitcoin-cli getblockchaininfo
```

```
$ bitcoin-cli getblockchaininfo
{
  "chain": "main",
  "blocks": 70185,
  "headers": 918316,  << ##เช็คจุดนี้
  "bestblockhash": "000000000149a911463409fada467aa6de45d6ec01ad5a89329777dd23f8fe09",
  "bits": "1c0168fd",
  "target": "000000000168fd00000000000000000000000000000000000000000000000000",
  "difficulty": 181.5432893640505,
  "time": 1280059453,
  "mediantime": 1280057059,
  "verificationprogress": 7.374078779552194e-05,
  "initialblockdownload": true,
  "chainwork": "000000000000000000000000000000000000000000000000000afd9a91ac8bc2",
  "size_on_disk": 28795004,
  "pruned": false,
  "warnings": [
  ]
}
```

สั่งหยุดการทำงาน bitcoind

```bash
sudo systemctl stop bitcoind
```

สั่งให้ bitcoind ทำงานโดยไม่เชื่อมต่อ peer

```bash
bitcoind -daemon -maxconnections=0
```

เพิ่ม utxo-snapshot เข้าไป

```bash
bitcoin-cli -rpcclienttimeout=0 loadtxoutset /path/to/utxo-snapshot-height-840000.dat
```

หลังนำเข้าเสร็จแล้วสั่งหยุด bitcoind

```bash
bitcoin-cli stop
```

สั่งให้ bitcoind ทำงานเป็น service อีกครั้ง

```bash
sudo systemctl restart bitcoind
```

> [!NOTE]
> Download a UTXO Snapshot file https://lopp.net/download/utxo-snapshot-height-840000.dat




## หากต้องการ Upgrade VERSION

วิธีอัปเกรดจะคล้ายกับการติดตั้งในข้างต้น เราแค่เปลี่ยน "VERSION=x.xx" ตามที่เราต้องการได้เลย
ตรวจสอบ release ล่าสุดได้ที่ [GitHub](https://github.com/bitcoin/bitcoin/releases) ของ Bitcoin core 

> [!NOTE]
> เมื่อมีการอัปเกรดอาจมีการเปลี่ยนโครงสร้างของ Bitcoin Core โปรดอ่านรายละเอียดใน Notes please ทุกครั้งเมื่อเราต้องอัปเกรด

ตั้งค่า version environment ที่ต้องการ

```sh
VERSION=x.x
```

ดาวน์โหลด Bitcoin core เวอร์ชั่นใหม่

```bash
wget https://bitcoincore.org/bin/bitcoin-core-$VERSION/bitcoin-$VERSION-aarch64-linux-gnu.tar.gz
```

> [!NOTE]
ตรวจสอบลายเซ็นของผู้พัฒนาตามขั้นตอนข้างต้น

แตกไฟล์ Bitcoin core

```bash
tar -xzvf bitcoin-$VERSION-aarch64-linux-gnu.tar.gz
```

ติดตั้ง Bitcoin core

```bash
sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-$VERSION/bin/bitcoin-cli bitcoin-$VERSION/bin/bitcoind
```

ตรวจสอบเวอร์ชั่นใหม่

```bash
bitcoind-cli --version
```

สั่ง restart Bitcoin core เพื่อใช้เวอร์ชั่นใหม่

```bash
sudo systemctl restart bitcoind
```