# Electrum server in rust (Electrs)



Electrum server เป็นตัวช่วยชั้นดีในการเชื่อมต่อโหนดเข้ากับ Wallet ได้ไวกว่า RPC จากโหนดโดยตรง และ Wallet ที่ใช้ร่วมกับ Hardware Wallet ส่วนมากจะใช้ Electrum server ในการเชื่อมต่อโหนดของตัวเอง

หน้าที่หลักคือการนำ UTXO จากโหนดมาทำ index ใหม่เพื่อให้ Wallet ค้นหาเจอง่ายและไวกว่า RPC โดยตรง

ในคู่มือนี้จะติดตั้ง Electrum server ที่เขียนขึ้นด้วยภาษา Rust ที่ชื่อว่า [Electrs](https://github.com/romanz/electrs)


### Requirements
* [Bitcoin Core](./bitcoind.md)
* [Rustup + Cargo](https://rust-lang.org/tools/install/)

> [!NOTE]


## วิธีติดตั้ง Electrs

สามารถอ่านเอกสารการติดตั้งอย่างเป็นทางการได้ที่ [Github](https://github.com/romanz/electrs/blob/master/doc/install.md) ของผู้พัฒนาโดยตรง


ตรวจสอบการอัปเดตของระบบก่อน

```bash
sudo apt update
```


### ติดตั้ง Cargo & Rust เพื่อ build Electrs

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

> [!NOTE]
> เลือกข้อ 1 หรือกด Enter เลยก็ได้

ตั้งค่าให้ใช้งานได้

```bash
. "$HOME/.cargo/env"  
```

ตรวจสอบเวอร์ชั่น Cargo & Rust

```bash
rustc --version
```

```bash
cargo --version
```

> [!NOTE]
>  cargo & rustc v 1.90.0 



### จัดการ Firewall และเพิ่ม ZMQ ใน bitcoin.conf

เปิด Port สำหรับ Electrs :50001

```bash
sudo ufw allow 50001/tcp comment 'electrs tcp'
```

```bash
sudo ufw allow 50002/tcp comment 'electrs ssl'
```

```bash
sudo ufw reload
```

เพิ่ม ZMQ ในไฟล์ bitcoin.conf

```bash
nano ~/.bitcoin/bitcoin.conf
```

เพิ่ม ZMQ ตามนี้

```
zmqpubrawblock=tcp://0.0.0.0:28332
zmqpubrawtx=tcp://0.0.0.0:28333
zmqpubhashblock=tcp://0.0.0.0:28334
whitelist=127.0.0.1
```

> [!NOTE]
> ZMQ เป็นฟังก์ชันที่ทำให้ Electrs สามารถดึงไฟล์ Raw block & tx จากโหนดได้


รีสตาร์ท bitcoind

```bash
sudo systemctl restart bitcoind
```

ตรวจสอบให้แน่ใจว่าทำงาน

```bash
sudo systemctl satatus bitcoind
```



### ติดตั้ง Electrs

ติดตั้งเครื่องมือที่ต้องใช้เพื่อ Build

```bash
sudo apt install -y build-essential libclang-dev git
```

ดาวน์โหลดซอร์สโค้ดโดยตรงจาก GitHub แล้วเข้าไปที่โฟลเดอร์ electrs

```bash
git clone https://github.com/romanz/electrs && cd electrs
```

Build electrs ใช้เวลาประมาณ 20 นาที

```bash
cargo build --locked --release
```

ตรวจสอบเวอร์ชั่น electrs

```bash
./target/release/electrs --version
```


### ตั้งค่า Electrs

สร้างไฟล์ electrs.toml

```bash
nano ~/electrs/electrs.toml
```
configuration

```
# connect bitcoind
network = "bitcoin"
cookie_file = "/home/username/.bitcoin/.cookie"
daemon_rpc_addr = "127.0.0.1:8332"
daemon_p2p_addr = "127.0.0.1:8333"

# electrs setting
electrum_rpc_addr = "0.0.0.0:50001"
db_dir = "/home/username/electrs/db"

timestamp = true
log_filters = "INFO"

```

> [!NOTE]
> อย่าลืมเปลี่ยน USERNAME ให้ตรงกับ user ของคุณ


ทดสอบ electrs 

```bash
./target/release/electrs
```

> [!NOTE]
> ถ้าไม่เจอ Error แสดงว่าใช้ได้ สามารถกด Ctrl+C เพื่อออกได้เลย



### สร้าง Systemd service

การสร้าง Systemd Service เพื่อให้ระบบสามารถเรียกใช้ Electrs โดยอัตโนมัติในพื้นหลังได้หลังปิด-เปิดเครื่อง

สร้างไฟล์ electrs.service

```bash
sudo nano /etc/systemd/system/electrs.service
```

configuration

```
[Unit]
Description=Electrs
After=bitcoind.service

[Service]
WorkingDirectory=/home/username/electrs
ExecStart=/home/username/electrs/target/release/electrs
User=username
Group=username
Type=simple
KillMode=process
TimeoutSec=60
Restart=always
RestartSec=60

Environment="RUST_BACKTRACE=1"

# Hardening measures
PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target
```

> [!NOTE]
> อย่าลืมเปลี่ยน USERNAME ให้ตรงกับ user ของคุณ

เปิดใช้งาน electrs.service

```bash
sudo systemctl daemon-reload
```

```bash
sudo systemctl enable electrs.service
```

```bash
sudo systemctl start electrs.service
```

ตรวจสอบว่า electrs ทำงานไหม

```bash
sudo systemctl status electrs.service
```

ตัวอย่าง:

```
$ sudo systemctl status electrs
● electrs.service - electrs
     Loaded: loaded (/etc/systemd/system/electrs.service; enabled; preset: enabled)
     Active: active (running) since Wed 2025-10-15 07:26:12 +07; 11h ago
   Main PID: 979 (electrs)
      Tasks: 20 (limit: 9067)
     Memory: 246.8M (peak: 632.1M)
        CPU: 45.892s
     CGroup: /system.slice/electrs.service
             └─979 /home/satoshi/electrs/target/release/electrs
```   

วิธีตรวจสอบ log

```bash
journalctl -fu electrs
```



## ตั้งค่า Hiddenservice Tor

เพิ่ม Hiddenservice เพื่อให้เข้าถึง electrs ผ่าน Tor ได้


แก้ไข Tor configuration

```bash
sudo nano /etc/tor/torrc
```

เพิ่ม configuration

```
# Electrs
HiddenServiceDir /var/lib/tor/electrs
HiddenServiceVersion 3
HiddenServicePort 50001 127.0.0.1:50001
HiddenServiceEnableIntroDoSDefense 1
```

สร้าง Directory สำหรับ Hidden Service

```bash
sudo mkdir -p /var/lib/tor/electrs
```

เปลี่ยน Ownership และ Permissions ของ Directory

```bash
sudo chown -R debian-tor:debian-tor /var/lib/tor/electrs
```

```bash
sudo chmod 700 /var/lib/tor/electrs
```

restart tor

```bash
restart Tor
```

วิธีตรวจสอบ Tor address

```bash
sudo cat /var/lib/tor/electrs/hostname
```

```
$ sudo cat /var/lib/tor/electrs/hostname
<tor-address>.onion
```




<div style="display: flex; justify-content: space-between;">
  <a href="./bitcoind.md">&lt;&lt; Bitcoin Core</a>
  <a href="./explorer.md">BTC RPC Explorer &gt;&gt;</a>
</div>


[Back to Linux/x86 README](./README.md)