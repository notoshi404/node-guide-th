# Albyhub Docker

คู่มือนี้จะแนะนำการ run albyhub docker container จาก docker image ของ [albyhub](https://github.com/getAlby/hub)

## วิธี Run Docker Container
### กำหนดค่า Environment variables

กำหนดค่าสำหรับ Albyhub ในไฟล์ [.env](.env)

* `UID` คือ ค่า user id ที่ใช้ run container
* `GID` คือ ค่า group id ที่ใช้ run container
* `VERSION` คือ version ที่ต้องการ run
* `HOST_ALBY_HUB_DATA_DIR` คือ ค่า directory ที่ใช้เก็บ data ของ albyhub ที่อยู่ใน host machine

### กำหนดค่าการเชื่อมต่อ Bitcoin Node
กำหนดค่า `environment` สำหรับเชื่อมต่อ Bitcoin Node ในไฟล์ [docker-compose.yml](docker-compose.yml)

#### ตัวเลือกที่ 1 - ใช้ค่า Default ของ Albyhub
ไม่ต้องกำหนดค่าอะไรเพิ่มเติม ซึ่งค่า default ของ albyhub จะเชื่อมต่อไปยัง https://electrs.getalbypro.com

#### ตัวเลือกที่ 2 - ใช้ค่า Esplora Server อื่น ๆ เช่น block stream หรือของตัวเอง
ให้กำหนดค่าดังนี้

```
LDK_ESPLORA_SERVER: https://blockstream.info/api
```

#### ตัวเลือกที่ 3 - ใช้ Electrum Server ของตัวเอง
ให้กำหนดค่าดังนี้

```
LDK_ELECTRUM_SERVER: electrum.example.com:50001
```

#### ตัวเลือกที่ 4 - ใช้ Bitcoin Node ของตัวเอง
ให้กำหนดค่าดังนี้

```
LDK_BITCOIND_RPC_HOST: 127.0.0.1
LDK_BITCOIND_RPC_PORT: 8332
LDK_BITCOIND_RPC_USER: ""
LDK_BITCOIND_RPC_PASSWORD: ""
```

**หมายเหตุ**
- ในกรณีที่ใช้ Bitcoin Node ของตัวเองและต้องการใช้ cookie file ในการ authentication ให้กำหนดค่าดังนี้

```
LDK_BITCOIND_RPC_USER="__cookie__"
LDK_BITCOIND_RPC_PASSWORD="{ค่า cookie auth ของ bitcoind ซึ่งดูได้จาก bitcoin data directory}"
```

- Default port ของ albyhub คือ 8080 ถ้าต้องการเข้า หน้าจอ albyhub ด้่วย http (port 80) หรือ https (port 443) ต้อง map port ของ albyhub ไปยัง port ของ host machine ใน [docker-compose.yml](docker-compose.yml)

```yaml
ports:
  - 80:8080
```

### Start docker container
ใช้คำสั่ง `docker compose up -d` เพื่อเริ่ม container

```sh
docker compose up -d
```

### Check docker container status

ใช้คำสั่ง `docker ps` เพื่อเช็ค status ของ container

```sh
docker ps
```

### Stop docker container

ใช้คำสั่ง `docker compose down` เพื่อหยุด container

```sh
docker compose down
```

### Restart docker container

ใช้คำสั่ง `docker compose restart` เพื่อ restart container

```sh
docker compose restart
```

[Back to main README](../README.md)
