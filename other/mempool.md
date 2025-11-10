# Mempool.space

mempool.space เป็นเว็บไซต์ Explorer ยอดนิยมที่ใช้เช็คธุรกรรมหรือเลขบล็อกของเหล่าบิตคอยน์เนอร์ เพราะมี UX/UI ที่เข้าใจง่ายและสวยงามจึงทำให้สะดวกในการใช้งาน

ก่อนที่จะไปติดตั้ง mempool.space เราจำเป็นต้องติดตั้ง Docker ก่อนเพราะเป็นวิธีที่ง่ายที่สุดในการติดตั้ง

> [!NOTE]
> หากยังไม่ได้ติดตั้ง Docker สามารถดูวิธีการติดตั้งได้ที่ [วิธีติดตั้ง Docker](./docker/install.md)




## ขั้นตอนติดตั้ง mempool.space

ตรวจสอบให้แน่ใจว่ามี Docker อยู่ในเครื่องโดยใช้คำสั่ง:

```bash
docker ps
```
ตัวอย่าง
```
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```



### จัดการ Firewall

เปิด Port สำหรับ mempool.space :8888

```bash
sudo ufw allow 8888/tcp comment 'mempool.space'
```

```bash
sudo ufw reload
```



### ดาวน์โหลดซอร์สโค้ดโดยตรงจาก GitHub

[GitHub mempool.space](https://github.com/mempool/mempool)

```bash
git clone https://github.com/mempool/mempool.git
```

เข้าไปที่โฟลเดอร์ docker ใน mempool

```bash
cd mempool/docker
```



### แก้ไขไฟล์ `docker-compose.yml`

ก่อนจะแก้ไขไฟล์ `docker-compose.yml` ต้องรู้ IP ของ Docker ก่อน
ใช้คำสั่ง:

```bash
ip a
```

ให้สังเกต inet ใน docker0

```
$ ip a
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 82:3a:64:20:a1:4d brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
```

> inet 172.17.0.1

แก้ไขไฟล์ `docker-compose.yml`

```bash
nano docker-compose.yml
```

แก้ไข port จาก 80 เป็น 8888

```
    ports:
      - 8888:8080
```

เพิ่ม environment สำหรับ electrum

```
  api:
    environment:
      MEMPOOL_BACKEND: "electrum"
      ELECTRUM_HOST: "172.17.0.1"
      ELECTRUM_PORT: "50001"
      ELECTRUM_TLS_ENABLED: "false"
```

แก้ไข environment สำหรับ Bitcoin Core และ RPC USER/PASS

```
  api:
    environment:
      CORE_RPC_HOST: "172.17.0.1"
      CORE_RPC_PORT: "8332"
      CORE_RPC_USERNAME: "<USER>"
      CORE_RPC_PASSWORD: "<PASS>"
```

เปลี่ยน `restart:` จาก on-failure เป็น always

```
    restart: always
```

กำหนด networks ในส่วนท้าย 

```
networks:
  default:
    driver: bridge
    ipam:
      config:
        - subnet: 172.16.57.0/24
```

ตัวอย่าง

```
version: "3.7"

services:
  web:
    environment:
      FRONTEND_HTTP_PORT: "8080"
      BACKEND_MAINNET_HTTP_HOST: "api"
    image: mempool/frontend:latest
    user: "1000:1000"
    restart: always
    stop_grace_period: 1m
    command: "./wait-for db:3306 --timeout=720 -- nginx -g 'daemon off;'"
    ports:
      - 8888:8080
  api:
    environment:
      MEMPOOL_BACKEND: "electrum"
      CORE_RPC_HOST: "172.17.0.1"
      CORE_RPC_PORT: "8332"
      CORE_RPC_USERNAME: "satoshi"
      CORE_RPC_PASSWORD: "satoshi-3592"
      ELECTRUM_HOST: "172.17.0.1"
      ELECTRUM_PORT: "50001"
      ELECTRUM_TLS_ENABLED: "false"
      DATABASE_ENABLED: "true"
      DATABASE_HOST: "db"
      DATABASE_DATABASE: "mempool"
      DATABASE_USERNAME: "mempool"
      DATABASE_PASSWORD: "mempool"
      STATISTICS_ENABLED: "true"
    image: mempool/backend:latest
    user: "1000:1000"
    restart: always
    stop_grace_period: 1m
    command: "./wait-for-it.sh db:3306 --timeout=720 --strict -- ./start.sh"
    volumes:
      - ./data:/backend/cache
  db:
    environment:
      MYSQL_DATABASE: "mempool"
      MYSQL_USER: "mempool"
      MYSQL_PASSWORD: "mempool"
      MYSQL_ROOT_PASSWORD: "admin"
    image: mariadb:10.5.21
    user: "1000:1000"
    restart: always
    stop_grace_period: 1m
    volumes:
      - ./mysql/data:/var/lib/mysql

networks:
  default:
    driver: bridge
    ipam:
      config:
        - subnet: 172.16.57.0/24
```

### รัน Container

หลังจากแก้ไขไฟล์ `docker-compose.yml` เสร็จสั่งรัน Container ได้เลย
โดยใช้คำสั่งนี้:

```bash
docker compose up -d
```

> [!NOTE]
> หลังจาก Container ทำงานแล้ว ให้เข้าบราวเซอร์เพื่อตรวจสอบได้เลยที่ `<ip>:8888`
