#!/usr/bin/env nix-shell
#! nix-shell -i bash -p mysql

mysqldump -h frcz-vps1 -u stats_rw -p statsdb > ./backups/frcz-vps1-mysql-statsdb-back-$(date +"%Y%m%d_%H%M%S").sql
