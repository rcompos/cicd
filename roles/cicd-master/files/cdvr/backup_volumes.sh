#!/bin/bash

cd /var/lib/docker/volumes

for dir in `echo cicd_*`; do
  echo "Backing up: $dir"
  tar cpf /root/cicd/bkup/$dir.tar ./$dir
done

