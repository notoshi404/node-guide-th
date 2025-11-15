# Bitcoin Core Docker

คู่มือนี้จะแนะนำการ run docker container จาก docker image ของ [lnliz/docker-bitcoind](https://github.com/lnliz/docker-bitcoind) ซึ่ง fork มาจาก [lncm/docker-bitcoind](https://github.com/lncm/docker-bitcoind) ที่ fork มาจาก [ruimarinho/docker-bitcoin-core](https://github.com/ruimarinho/docker-bitcoin-core) อีกที ใน repository นี้ จะมี Dockerfile ที่ใช้ในการสร้าง image bitcoin สามารถเข้าไปตรวจสอบกันได้เลยครับ

## วิธี Run Docker Container
### Environment Variables

กำหนดค่า Environment Variables ในไฟล์ [.env](.env)

#### Bitcoin
* `UID` คือ ค่า user id ที่ใช้ run container
* `GID` คือ ค่า group id ที่ใช้ run container
* `IMAGE_NAME` ชื่อ image ที่ต้องการ run
* `VERSION` คือ version ที่ต้องการ run
* `HOST_DATA_DIR` คือ ค่า directory ที่ใช้เก็บ data ของ bitcoin ที่อยู่ใน host machine

#### Tor
* `TOR_GID` คือ ค่า group id ที่ใช้ run tor ใน host machine เพื่อให้ docker add user ที่เราใช้ในการ run เข้าไปใน tor group เพื่ออ่านไฟล์ auth cookie ของ tor
* `TOR_AUTH_COOKIE_FILE` คือค่า file path ที่ใช้เก็บ auth cookie ของ tor ที่อยู่ใน host machine ใช้สำหรับเชื่อมต่อ tor control เพื่อ hidden service

**หมายเหตุ:**
- ถ้าต้องการใช้ tor จำเป็นต้องมีค่า `TOR_GID` และ `TOR_AUTH_COOKIE_FILE` ในการ run bitcoin daemon
- ถ้าไม่ต้องการใช้ tor ในการ run bitcoin daemon ให้ลบ 2 ส่วนนี้ใน [docker-compose.yml](docker-compose.yml) ได้เลย
```yml
group_add:
      - ${TOR_GID}
```
```yml
- ${TOR_AUTH_COOKIE_FILE}:/run/tor/control.authcookie:ro
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
