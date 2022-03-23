#!/bin/bash
docker compose exec peter-kafka01.foo.bar systemctl restart kafka-server
docker compose exec peter-kafka02.foo.bar systemctl restart kafka-server
docker compose exec peter-kafka03.foo.bar systemctl restart kafka-server
