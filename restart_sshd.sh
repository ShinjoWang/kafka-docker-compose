#!/bin/bash
docker compose exec peter-ansible01.foo.bar systemctl restart sshd
docker compose exec peter-kafka01.foo.bar systemctl restart sshd
docker compose exec peter-kafka02.foo.bar systemctl restart sshd
docker compose exec peter-kafka03.foo.bar systemctl restart sshd
docker compose exec peter-zk01.foo.bar systemctl restart sshd
docker compose exec peter-zk02.foo.bar systemctl restart sshd
docker compose exec peter-zk03.foo.bar systemctl restart sshd
