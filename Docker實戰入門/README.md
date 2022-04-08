# Docker實戰入門
![](https://i.imgur.com/CqI2MHx.png)

## 1.1. 什麼是Docker
容器基於共用linux kernel
### 1.1.1. Docker主要組成
- Docker Container
- Docker Engine (Runtime)

#### 1.1.1.1. Build
- 參與並簡化CI/CD流程
#### 1.1.1.2. Share
- 可攜性
#### 1.1.1.3. Run
- 運行環境相同
- 獨立執行環境

## 1.2. 虛擬化 v.s. 容器化

|           | VM               | Container           |
|-----------|------------------|---------------------|
| 隔離      | OS層(共用硬體層) | Process層(共用OS層) |
| Image體積 | 大               | 小                  |
| 占用資源  | 大               | 小                  |
| 啟動速度  | 慢               | 快                  |

## 1.3. Docker Desktop for Windows

### 1.3.1. Install
#### 1.3.1.1. Installer
https://www.docker.com/get-started/
#### 1.3.1.2. Chocolatey
```` sh
choco install docker-desktop
````
## 1.4. Container Image Repository (Container Registry)
- [DockerHub](https://hub.docker.com/)
- Github Packages
- Azure Container Registry
- etc.

## 1.5. Docker 常用指令
### 1.5.1. pull
下載容器image，預設從DockerHub
````sh
docker pull busybox
````
### 1.5.2. run
執行一個容器，如果不存在image，則會自動進行pull
````sh
docker pull busybox
````
常用參數，要注意參數擺放位置
- `-d`背景執行
- `-P`隨機prot映射
- `-p`指定port映射
- `--name`為容器命名
- `-e`設定環境變數
- `-v`綁定volume
- `-i` 互動模式
- `-t` 分配容器TTY並綁定到標準輸出
- `-it` -i及-t同時使用，俗稱進到容器裡操作
### 1.5.3. stop
停止容器
````sh
// e1是容器的uuid
docker stop e1
````
### 1.5.4. rm
刪除容器
````sh
// e1是容器的uuid
docker rm e1
````
### 1.5.5. ps
容器執行狀態(image, uuid, command, 創建時間, 狀態, 占用port, 名稱)
````sh
docker ps
````
````sh
// 加上-a可以看到非執行狀態中的容器
docker ps -a
````
## 1.6. 容器儲存資料
Docker不會儲存狀態，每次重啟容器都是新的開始，因此必須掛載儲存體來儲存容器中記錄的資料

### 1.6.1. Volume
````sh
// 創建一個volume
docker volume create volume_name
````
````sh
// 綁定volume
docker run -v volume_name:Container_paht Image_mane
````
````sh
// volume不存在時會以uuid自動生成
docker run -v Container_paht Image_name
````

### 1.6.2. 路徑映射
````sh
// 將容器內與容器外的檔案系統綁定
docker run -v 絕對位置:Container_paht Image_name
````

## 1.7. 如何製作DOCKERFILE & 建構一個Image
 DOCKERFILE可以使CI/CD中的Build及Deploy的部分更簡單
### 1.7.1. 簡單的DOCKERFILE
````dockerfile
FROM golang:1.18
WORKDIR /go/src
COPY main.go .
COPY go.mod .
ENV CGO_ENABLED=0
RUN go get -d -v ./...
RUN go build -a -installsuffix cgo -o main .
EXPOSE 8080/tcp
ENTRYPOINT ["./main"]
````
### 1.7.2. Build&RUN
````sh
docker build -t Image_name Path
````
### 1.7.3. 進階的DOCKERFILE
````dockerfile
FROM golang:1.18 AS build
WORKDIR /go/src
COPY main.go .
COPY go.mod .
ENV CGO_ENABLED=0
RUN go get -d -v ./...
RUN go build -a -installsuffix cgo -o main .

FROM scratch AS runtime
WORKDIR /app
COPY --from=build /go/src/main ./
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
EXPOSE 8080/tcp
ENTRYPOINT ["./main"]
````
## 1.8. 好用的GUI工具
https://www.portainer.io/
### 1.8.1. Install
````sh
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.11.1
````
## 1.9. Docker-compose
一個可以一次啟動多個容器的工具

````yml
version: '2'
services:
  db:
     image: mysql
     environment:
        MYSQL_ROOT_PASSWORD: 123456
  admin:
     image: adminer
     ports:
       - 8080:8080
````

## 1.10. Contanier Cluster
容器的可攜性使其可以在任意的主機上進行部署  
因此加入Cluster技術後可以使容器在多台主機中進行資源調度  

容器調度管理器
### 1.10.1. Kubernetes (k8s)
- 主流管理器
- 功能很多很強
- 資源及套件很充足
- 非常複雜且難度非常高

### 1.10.2. Docker Swarm
- 極輕量化
- Docker原生
- 更簡單

### 1.10.3. K3s
- k8s官方認證
- 輕量化
- 邊緣運算


## 1.11. 投票下次內容
- 宇宙最強程式語言 - Golang
- 為AI而生的程式語言 - Deno
- Dart語言腳踏三條船 - Flutter2.0
- 免費又開源的虛擬機叢集 - ProxmoxVE
- SPA中的宇宙戰艦 - Angular

## 1.12. 範例程式
[Github](https://github.com/Ruisi-Lu/open-course-ware/tree/main/Docker%E5%AF%A6%E6%88%B0%E5%85%A5%E9%96%80)


###### tags: `入門`, `Ruisi`, `DevOps`