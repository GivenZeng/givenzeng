#!/bin/bash
/usr/bin/mysqldump -u root -pyourpasspord --all-databases > `date +'%Y-%m-%d-%H'`.sql
