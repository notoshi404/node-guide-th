# Albyhub Docker

คู่มือนี้จะแนะนำการ run albyhub docker container จาก docker image ของ [albyhub](https://github.com/getAlby/hub)

## วิธี Run Docker Container
### Environment Variables

กำหนดค่า Environment Variables ในไฟล์ [.env](.env)

#### Albyhub
* `UID` คือ ค่า user id ที่ใช้ run container
* `GID` คือ ค่า group id ที่ใช้ run container
* `VERSION` คือ version ที่ต้องการ run
* `HOST_ALBY_HUB_DATA_DIR` คือ ค่า directory ที่ใช้เก็บ data ของ albyhub ที่อยู่ใน host machine

#### Bitcoind
ถ้าต้องการเชื่อมต่อ albyhub เข้ากับ bitcoind ของตัวเอง ให้กำหนดค่า env ดังนี้

```
LDK_BITCOIND_RPC_HOST: 127.0.0.1
LDK_BITCOIND_RPC_PORT: 8332
LDK_BITCOIND_RPC_USER: ""
LDK_BITCOIND_RPC_PASSWORD: ""
```

**หมายเหตุ**
- ถ้าต้องการใช้ cookie file ในการ authentication ให้กำหนดค่า env ดังนี้

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
