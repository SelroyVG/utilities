#!/bin/bash
HOST="localhost" #MySQL host
USER="scc" #MySQL username
PASSWD="ZQLf-0.4" #MySQL password

echo "spider name,spider host" >> spider_hosts.csv

for row in $(echo "SELECT db_name FROM scc.spider" | mysql -u $USER --password=$PASSWD); do
	if [ $row != "db_name" ]
	then
		echo "$row,`mysql -u $USER --password=$PASSWD -h $HOST -N -e "select arg1 from $row.spider_commands where command = 13 and arg2=22 ORDER BY id LIMIT 1"`" >> spider_hosts.csv
	fi
done

exit 0