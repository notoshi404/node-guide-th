# The Invisible Internet Project (I2P)

[i2p](https://geti2p.net) คือเครือข่ายอินเทอร์เน็ตลับที่สร้างขึ้นซ้อนทับบนอินเทอร์เน็ตปกติอีกที ระบบและการออกแบบของ i2p จะมีความแตกต่างกับ tor อย่างสิ้นเชิงโดยเฉพาะการเชื่อมต่อหา node อื่น ๆ จะสามารถเชื่อมต่อได้กับ node ที่อยู่ในเครือข่าย i2p เท่านั้น ซึ่งเราสามารถ config bitcoin node ของเรา ให้สามารถเชื่อมต่อกับ peer ที่อยู่ใน network i2p ได้

**หมายเหตุ** คู่มือนี้จะแนะนำการติดตั้งบน Debian 12 (Bookworm) หากท่านใดต้องการติดตั้งบน os อื่น ๆ สามารถอ่านคู่มือได้จาก website ของ [i2p download](https://geti2p.net/en/download) โดยตรงเลยครับ

## Install i2p

- อัปเดตระบบ

```sh
sudo apt-get update
```

- ติดตั้ง library ที่จำเป็นสำหรับ i2p

```sh
sudo apt-get install apt-transport-https lsb-release curl
```

- สร้างไฟล์ /etc/apt/sources.list.d/i2p.list โดยใช้คำสั่งต่อไปนี้

ไฟล์ `/etc/apt/sources.list.d/i2p.list` มีไว้บอก os package manager ว่าให้ติดตั้ง i2p จาก repository official ของ i2p นะ

```sh
echo "deb [signed-by=/usr/share/keyrings/i2p-archive-keyring.gpg] https://deb.i2p.net/ $(lsb_release -sc) main" \
  | sudo tee /etc/apt/sources.list.d/i2p.list
```

- โหลด key สำหรับตรวจสอบ repository

```sh
curl -o i2p-archive-keyring.gpg https://geti2p.net/_static/i2p-archive-keyring.gpg
```

- ตรวจสอบ key fingerprint

```sh
gpg --keyid-format long --import --import-options show-only --with-fingerprint i2p-archive-keyring.gpg
```
ต้องมี fingerprint เป็นค่าตามข้อที่ 4 ของ [link นี้](https://geti2p.net/en/download/debian#debian)

- copy key ไปที่ /usr/share/keyrings/i2p-archive-keyring.gpg

```sh
sudo cp i2p-archive-keyring.gpg /usr/share/keyrings
```

- บอก package manager ว่ามี repository ใหม่นะ

```sh
sudo apt-get update
```

- ติดตั้ง i2p

```sh
sudo apt-get install i2p i2p-keyring
```

## Config i2p Service
- เริ่มต้นตั้งค่า i2p ด้วยคำสั่ง
```sh
sudo dpkg-reconfigure i2p
```
หลังจากนั้นให้ตั้งค่าตามหน้าจอที่ขึ้นมาให้เสร็จ หลัก ๆ จะเป็นเรื่องให้ start i2p ตอนที่ reboot เครื่องกับเรื่อง user ที่ใช้ run i2p

## Start i2p

- รัน i2p ด้วยคำสั่ง
```sh
sudo systemctl start i2p
```

- ตรวจสอบ i2p status ด้วยคำสั่ง

```sh
sudo systemctl status i2p
```

## ตรวจสอบ i2p SAM Bridge
ขั้นตอนนี้จะเป็นการเข้าไปตรวจสอบ SAM Bridge ที่จะใช้เป็นช่องทางในการเชื่อมต่อระหว่าง i2p และ bitcoin node ผ่านหน้า i2p console

- เข้าไปที่
```
http://127.0.0.1:7657/configclients
```

ตรวจสอบ SAM application bridge
1. มีติ๊กถูกตรง Run at Startup? ถ้าไม่มีติ๊กถูกให้ติ๊กแล้วกด Save Client Configurations
2. ดูตรง Control ต้องเป็นรูปปุ่ม stop และดูตรงมุมซ้ายล่างของจอว่ามี SAM Client run อยู่ไหม

## บอก bitcoin node ว่าให้เปิดใช้งาน i2p

ตัวอย่าง `bitcoin.conf` ที่เปิดใช้งาน i2p
```
i2p=1
i2pacceptincoming=1
i2psam=127.0.0.1:7656
onlynet=i2p
```

หลังจากแก้ไข bitcoin.conf ให้รีสตาร์ต bitcoin node แล้วลองใช้คำสั่ง

```sh
bitcoin-cli -netinfo
```

ถ้าเห็นส่วนของ Local addresses แสดง เป็นอันโอเค
```
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.b32.i2p
```

ถ้าไม่ขึ้นแบบนี้อาจจะต้องเข้าไปดู log ของ node ว่ามีปัญหาอะไร ทำไมถึงต่อ i2p ไม่ได้

[Back to Raspberry Pi README](./README.md)
