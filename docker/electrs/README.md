# Electrs Docker

คู่มือนี้จะแนะนำการสร้าง docker image และ docker container จาก repository ของ [Electrs](https://github.com/romanz/electrs)

## วิธี Build Docker Image
### Build Docker Image
เพื่อสร้าง docker image ของ Electrs ให้เรียกใช้คำสั่ง `./build/build.sh` ในโฟลเดอร์ [build](build) ของโปรเจค

```
./build/build.sh
```

ใน script นี้จะกำหนดค่าเริ่มต้นของ IMAGE_NAME และ VERSION ให้คุณ ซึ่งคุณสามารถแก้ไขค่าเหล่านี้ได้ตามความต้องการ
 หลังจาก run script แล้ว อาจจะใช้เวลาในการ compile rust project และ build docker image สักระยะนึง

### Dockerfile
[build/build.sh](build/build.sh) ทำหน้าที่สร้าง docker image จาก Dockerfile

ซึ่งคุณสามารถตรวจสอบการทำงานและทำความเข้าใจ [Dockerfile](build/Dockerfile) ได้ในโฟลเดอร์ [build](build)

### ตรวจสอบ Docker Image
หลังจากสร้าง docker image แล้ว คุณสามารถตรวจสอบ docker image ที่สร้างได้โดยเรียกใช้คำสั่ง `docker images`

```
docker images
```

คำสั่ง `docker images` จะแสดงรายการของ docker image ที่มีอยู่ในเครื่องของคุณ

```
$ docker images
REPOSITORY            TAG       IMAGE ID       CREATED        SIZE
local/electrs         v0.10.9   1b22aef2becb   3 months ago   111MB
```

## วิธี Run Docker Container
### Environment Variables

กำหนดค่า Environment Variables ในไฟล์ [.env](run/.env)

* `UID` คือ ค่า user id ที่ใช้ run container

* `GID` คือ ค่า group id ที่ใช้ run container

* `ELECTRS_IMAGE_NAME` ชื่อ image ที่ build จาก step ก่อนหน้า

* `ELECTRS_VERSION` คือ version ของ image ที่ build จาก step ก่อนหน้า

* `ELECTRS_LOG_FILTERS` คือ Log level ของ electrs ปกติจะกำหนดเป็น INFO

* `ELECTRS_NETWORK` คือ Network ที่ต้องการรัน ปกติจะกำหนดเป็น bitcoin

* `ELECTRS_HOST_DB_DIR` คือ Directory ที่ใช้เก็บ database ของ electrs บน host machine

* `ELECTRS_DB_DIR` คือ Directory ที่ใช้เก็บ database ของ electrs ภายใน container ซึ่งจะเป็น `/home/${USER}/electrs/db`

* `ELECTRS_HOST_DAEMON_DIR` คือ Directory ที่ใช้เก็บข้อมูล bitcoin daemon บน host machine

* `ELECTRS_DAEMON_DIR` คือ Directory ที่ใช้เก็บข้อมูล bitcoin daemon ภายใน container ซึ่งจะเป็น `/home/${USER}/electrs/bitcoin`

* `ELECTRS_DAEMON_RPC_ADDR` คือ bitcoin daemon rpc address

* `ELECTRS_DAEMON_P2P_ADDR` คือ bitcoin daemon p2p address

* `ELECTRS_ELECTRUM_RPC_ADDR` คือ electrum rpc address ที่เราจะ expose ให้สามารถเชื่อมต่อได้

`${USER}` ในที่นี้จะหมายถึง user ของ host machine ที่ใช้ build docker image

### Start docker container
เข้าไปที่ [run](run) แล้วใช้คำสั่ง `docker compose up -d` เพื่อเริ่ม container

```
docker compose up -d
```

### Check docker container status

ใช้คำสั่ง `docker ps` เพื่อเช็ค status ของ container

```
docker ps
```

### Stop docker container

ใช้คำสั่ง `docker compose down` เพื่อหยุด container

```
docker compose down
```

### Restart docker container

ใช้คำสั่ง `docker compose restart` เพื่อ restart container

```
docker compose restart
```

[Back to main README](../README.md)
