#!/bin/bash

cd /var/lib/docker/volumes

for dir in `echo cdvr_*`; do
  echo "Backing up: $dir"
  tar cpf /home/root/cdvr/cdvr-bkup/$dir.tar ./$dir
done

