# Bitcoin explorer: BTC RPC Explorer



BTC RPC Explorer เป็นเว็บอินเทอร์เฟซที่มีน้ำหนักเบา ใช้งานง่าย ช่วยให้คุณสามารถ “สำรวจบล็อกเชนบิตคอยน์” ได้ด้วยตนเองแบบสะดวก
มันเป็น blockchain explorer แบบไม่ใช้ฐานข้อมูล (database-free) และสามารถ self-hosted โดยจะดึงข้อมูลโดยตรงจาก Bitcoin Core และ Electrs ผ่าน RPC


### Requirements
* [Bitcoin Core](./bitcoind.md)
* [Node+npm](https://nodejs.org/en/download)

> [!NOTE]
> npm v7+ is required

## วิธีติดตั้ง BTC RPC Explorer

สามารถอ่านเอกสารการติดตั้งอย่างเป็นทางการได้ที่ [Github](https://github.com/janoside/btc-rpc-explorer) ของผู้พัฒนาโดยตรง


ตรวจสอบการอัปเดตของระบบก่อน

```bash
sudo apt update
```


### ติดตั้ง Node + npm

ดาวน์โหลดและติดตั้ง nvm

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

ใช้คำสั่งนี้แทนการรีสตาร์ต shell

```bash
\. "$HOME/.nvm/nvm.sh"
```

ดาวน์โหลดและติดตั้ง Node.js

```bash
nvm install 24
```

ตรวจสอบเวอร์ชันของ Node.js "v24.10.0"

```bash
node -v
```

ตรวจสอบเวอร์ชันของ npm "11.6.1"

```bash
npm -v
```



### จัดการ Firewall

เปิด Port สำหรับ BTC RPC Explorer :3002

```bash
sudo ufw allow 3002/tcp comment 'btc-rpc-explorer'
```

```bash
sudo ufw reload
```



### ตรวจสอบไฟล์ `bitcoin.conf`
 
ตรวจสอบว่าได้ใส่ค่า 3 อย่างนี้ไว้ไหม หาไม่มีให้เพิ่มเข้าไปในไฟล์ `bitcoin.conf`

```
txindex=1
blockfilterindex=1
coinstatsindex=1
```



### ติดตั้ง BTC RPC Explorer

ดาวน์โหลดซอร์สโค้ดโดยตรงจาก GitHub แล้วเข้าไปที่โฟลเดอร์ btc-rpc-explorer

```bash
git clone https://github.com/janoside/btc-rpc-explorer.git && cd btc-rpc-explorer
```

ติดตั้ง dependencies ทั้งหมดโดยใช้คำสั่ง npm

```bash
npm install
```

### ตั้งค่า BTC RPC Explorer

สร้างไฟล์ .env

```bash
nano .env
```

configuration

```
BTCEXP_HOST=0.0.0.0
BTCEXP_PORT=3002

# Conncet Bitcoin
BTCEXP_BITCOIND_HOST=127.0.0.1
BTCEXP_BITCOIND_PORT=8332
BTCEXP_BITCOIND_COOKIE=/home/<USERNAME>/.bitcoin/.cookie
BTCEXP_BITCOIND_RPC_TIMEOUT=0

# Conncet Electrs
BTCEXP_ADDRESS_API=electrum
BTCEXP_ELECTRUM_SERVERS=tcp://127.0.0.1:50001
BTCEXP_ELECTRUM_TXINDEX=true

# Use bitcoin-cli
#BTCEXP_BASIC_AUTH_PASSWORD=mypassword
```

ทดสอบการตั้งค่า

```bash
npm start
```

เข้าเว็บเบราว์เซอร์แล้วพิมพ์ "<ip>:<port>"
เช่น "192.168.x.xxx:3002"
> [!NOTE]
> หากหน้าเว็บไซค์ทำงานปกติกดฟังค์ชั่นต่าง ๆ สามารถกด clt+c ออกได้เลย



### สร้าง Systemd service

การสร้าง Systemd Service เพื่อให้ระบบสามารถเรียกใช้ btc rpc explorer โดยอัตโนมัติในพื้นหลังได้หลังปิด-เปิดเครื่อง


สร้างไฟล์ btcrpcexplorer.service

```bash
sudo nano /etc/systemd/system/btcrpcexplorer.service
```

configuration

```
[Unit]
Description=BTC RPC Explorer
Requires=bitcoind.service electrs.service
After=bitcoind.service electrs.service

[Service]
WorkingDirectory=/home/username/btc-rpc-explorer
ExecStart=/home/username/.nvm/versions/node/v24.10.0/bin/npm start

Environment=PATH=/home/username/.nvm/versions/node/v24.10.0/bin:/usr/bin:/bin
Environment=NODE_ENV=production

User=username
Group=username

# Hardening Measures
####################
PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true
PrivateDevices=true

[Install]
WantedBy=multi-user.target
```

> [!NOTE]
> อย่าลืมเปลี่ยน USERNAME ให้ตรงกับ user ของคุณ
> และสำหรับคนที่ติดตั้ง Node.js ด้วย nvm ใช้คำสั่ง "which npm" เพื่อหาที่อยู่ของ npm ก่อนค่อยนำมาใส่ใน ExecStart

เปิดใช้งาน btcrpcexplorer.service

```bash
sudo systemctl daemon-reload
```

```bash
sudo systemctl enable btcrpcexplorer.service
```

```bash
sudo systemctl start btcrpcexplorer.service
```

ตรวจสอบว่า BTC RPC Explorer ทำงานไหม

```bash
sudo systemctl status btcrpcexplorer.service
```



## ตั้งค่า Hiddenservice Tor

เพิ่ม Hiddenservice เพื่อให้เข้าถึง BTC RPC Explorer ผ่าน Tor ได้


แก้ไข Tor configuration

```bash
sudo nano /etc/tor/torrc
```

เพิ่ม configuration

```
# BTC RPC Explorer
HiddenServiceDir /var/lib/tor/bitcoinexplorer
HiddenServiceVersion 3
HiddenServicePort 3002 127.0.0.1:3002
HiddenServiceEnableIntroDoSDefense 1
```

สร้าง Directory สำหรับ Hidden Service

```bash
sudo mkdir -p /var/lib/tor/bitcoinexplorer
```

เปลี่ยน Ownership และ Permissions ของ Directory

```bash
sudo chown -R debian-tor:debian-tor /var/lib/tor/bitcoinexplorer
```

```bash
sudo chmod 700 /var/lib/tor/bitcoinexplorer
```

restart tor

```bash
restart Tor
```

วิธีตรวจสอบ Tor address

```bash
sudo cat /var/lib/tor/bitcoinexplorer/hostname
```

```
$ sudo cat /var/lib/tor/bitcoinexplorer/hostname
<tor-address>.onion
```


<div style="display: flex; justify-content: flex-start;">
  <a href="./electrs.md">&lt;&lt; Electrs</a>
</div>

[Back to Raspberry Pi README](./README.md)