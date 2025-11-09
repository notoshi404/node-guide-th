# วิธีติดตั้ง Docker



## วิธีติดตั้ง

คุณสามารถไปเอกสารประกอบทางการเองได้ที่ https://docs.docker.com/engine/install/ แต่ในคู่มือนี้เราจะใช้วิธีที่ง่ายที่สุด

### ดาวโหลดสคริปและติดตั้ง

ดาวโหลดสคริป

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
```

รันสคริปติดตั้ง

```bash
sudo sh get-docker.sh
```

ตรวจสอบเวอร์ชั่น

```bash
docker --version
```

ตรวจสอบสถานะ Docker

```bash
sudo systemctl status docker
```


### วิธีตั้งค่าให้ใช้คำสั่ง docker โดยไม่ได้ใช้ sudo

โดยเริ่มต้นคำสั่ง docker จำเป็นต้องใช้สิทธิ์ root หรือใช้ sudo ในการรันคำสั่ง เราจะมาตั้งให้มาอยู่กลุ่มเดียวกันโดยใช้คำสั่งนี้

```bash
sudo usermod -aG docker ${USER}
```

สลับเข้าสู่ user อีกครั้ง

```bash
su - ${USER}
```

ทดสอบคำสั่ง

```bash
docker ps
```



## คำสั่งพื้นฐาน Docker


| คำสั่ง | ความหมาย | ตัวอย่างการใช้งาน |
|:--------|:-----------|:------------------|
| `docker pull` | ดาวน์โหลด Image จาก Docker Hub มาไว้ในเครื่องของเรา | `docker pull nginx` |
| `docker images` | แสดงรายการ Image ทั้งหมดที่มีอยู่ในเครื่อง | `docker images` |
| `docker build` | สร้าง Image ใหม่จากไฟล์ Dockerfile | `docker build -t myapp:1.0 .` |
| `docker rmi` | ลบ Image ที่ไม่ได้ใช้งานออกจากเครื่อง (rmi = remove image) | `docker rmi nginx` |
| `docker ps` | แสดง Container ที่กำลังทำงานอยู่ | `docker ps` |
| `docker ps -a` | แสดง Container ทั้งหมด รวมถึงที่หยุดแล้ว | `docker ps -a` |
| `docker run` | รัน Container ใหม่จาก Image | `docker run -it ubuntu /bin/bash` |
| `docker start` | เริ่ม Container ที่หยุดไว้ | `docker start my_container` |
| `docker stop` | หยุด Container ที่กำลังทำงาน | `docker stop my_container` |
| `docker rm` | ลบ Container ที่ไม่ใช้งานแล้ว | `docker rm my_container` |
| `docker exec` | รันคำสั่งภายใน Container ที่กำลังทำงานอยู่ | `docker exec -it my_container /bin/bash` |
| `docker logs` | แสดง log ของ Container | `docker logs my_container` |
| `docker network ls` | แสดงรายการ Network ทั้งหมด | `docker network ls` |
| `docker network create` | สร้าง Network ใหม่ | `docker network create my_network` |
| `docker compose up -d` | รันบริการทั้งหมดจากไฟล์ `docker-compose.yml` แบบ background | `docker compose up -d` |
| `docker compose down` | หยุดและลบ container, network, volume ที่สร้างจาก compose | `docker compose down` |

---

**หมายเหตุเพิ่มเติม**
- `-d` → รันเบื้องหลัง (detached mode)  
- `--name` → ตั้งชื่อ container  
- `-p` → เปิดพอร์ต เช่น `-p 8080:80`  
- `-v` → mount โฟลเดอร์ เช่น `-v /data:/app/data`  

---

**อ้างอิง:**  
[Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/docker/)


