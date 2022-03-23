# Kafka-docker-compose

`docker-compose` 로 local 환경에서 클러스터 구성

## Build
```bash
# root 사용자 패스워드 변경 (default: asdf)
$ vi Dockerfile
RUN echo 'root:asdf' | chpasswd
-> RUN echo 'root:anythingyouwant' | chpasswd

# Kafka, zookeeper 설치 클러스터
$ docker build . -t centos/sshd

# Ansible 클러스터
$ docker build . -t centos/ansible -f Dockerfile-ansible
```

## Run
- 전체 클러스터 docker compose로 실행
```bash
$ docker compose up -d
[+] Running 8/8
 ⠿ Network kafka-docker-compose_default                      Created    0.0s
 ⠿ Container kafka-docker-compose-peter-zk03.foo.bar-1       Running    1.1s
 ⠿ Container kafka-docker-compose-peter-zk02.foo.bar-1       Running    0.9s
 ⠿ Container kafka-docker-compose-peter-kafka03.foo.bar-1    Running    1.3s
 ⠿ Container kafka-docker-compose-peter-kafka02.foo.bar-1    Running    0.9s
 ⠿ Container kafka-docker-compose-peter-ansible01.foo.bar-1  Running    0.6s
 ⠿ Container kafka-docker-compose-peter-zk01.foo.bar-1       Running    1.2s
 ⠿ Container kafka-docker-compose-peter-kafka01.foo.bar-1    Running    1.1s
```

- 무한정 대기하며 리소스를 차지하는 getty 서비스를 중지/삭제 해줌
```bash
$ ./stop_getty.sh
Removed /etc/systemd/system/getty.target.wants/getty@tty1.service.
Removed /etc/systemd/system/getty.target.wants/getty@tty1.service.
Removed /etc/systemd/system/getty.target.wants/getty@tty1.service.
Removed /etc/systemd/system/getty.target.wants/getty@tty1.service.
Removed /etc/systemd/system/getty.target.wants/getty@tty1.service.
Removed /etc/systemd/system/getty.target.wants/getty@tty1.service.
Removed /etc/systemd/system/getty.target.wants/getty@tty1.service.
```

- sshd가 실행되지 않았을 경우가 있으므로 restart 해줌
```bash
$ ./restart_sshd.sh
```

- ansible로 접속
```bash
$ docker compose exec peter-ansible01.foo.bar /bin/bash
[root@d32fca880425 /]
```

- ssh public key 만들기
```bash
[root@d32fca880425 /] ssh-keygen
엔터 엔터 엔터
```

- 생성된 public key 연결
```bash
[root@d32fca880425 /] ssh-copy-id peter-kafka01.foo.bar
[root@d32fca880425 /] ssh-copy-id peter-kafka02.foo.bar
[root@d32fca880425 /] ssh-copy-id peter-kafka03.foo.bar
[root@d32fca880425 /] ssh-copy-id peter-zk01.foo.bar
[root@d32fca880425 /] ssh-copy-id peter-zk02.foo.bar
[root@d32fca880425 /] ssh-copy-id peter-zk03.foo.bar
```

- `실전 카프카 개발부터 운영까지` git 다운로드
```bash
[root@d32fca880425 /] cd
[root@d32fca880425 ~] git clone https://github.com/onlybooks/kafka2
[root@d32fca880425 ~] cd kafka2/chapter2/ansible_playbook
```

- ansible 접속 확인
```bash
[root@d32fca880425 ansible_playbook] ansible -i hosts all -m ping
전부 SUCCESS 뜨면 됨
```

- kafka와 zookeeper 설치
```bash
[root@d32fca880425 ansible_playbook] ansible-playbook -i hosts zookeeper.yml
[root@d32fca880425 ansible_playbook] ansible-playbook -i hosts kafka.yml
```

- 설치 확인
```bash
[root@d32fca880425 ansible_playbook] ssh peter-zk01.foo.bar systemctl status zookeeper-server
[root@d32fca880425 ansible_playbook] ssh peter-kafka01.foo.bar systemctl status kafka-server
```

## Stop
```bash
$ docker compose stop
```

## Restart
```bash
$ docker compose start

# sshd 실행 안될 때가 있음
$ ./restart_sshd.sh

# 재시작 시 zookeeper는 자동실행 되지만 kafka는 실행시켜 줘야 함
$ ./start_kafka.sh
```

## Test Spec
- Docker Desktop 4.5.0 (74594)
- Docker Engine 20.10.12
- Docker Compose v2.2.3