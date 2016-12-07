#!/bin/bash
MODE=$1
DUMPSDIR=$2 #Spider's dumps directory 
HOST=$3 #MySQL host
USER=$4 #MySQL username
PASSWD=$5 #MySQL password
SPIDER_NAME=$6

if [ $MODE = "dump" ]
then
	#rm -r -f $DUMPSDIR
	mkdir $DUMPSDIR
	query="SHOW TABLES where tables_in_"$SPIDER_NAME" not like 'spider_commands';"
	mysql -u $USER --password=$PASSWD -h $HOST $SPIDER_NAME -N -e "$query" | xargs mysqldump --user=$USER --password=$PASSWD -h $HOST $SPIDER_NAME --tables --no-data > "$DUMPSDIR/$SPIDER_NAME.sql"
	mysqldump --user=$USER --password=$PASSWD -h $HOST $SPIDER_NAME --tables spider_commands --no-create-info > "$DUMPSDIR/"$SPIDER_NAME"_commands.sql"
	
	echo "Dump for $SPIDER_NAME created"
fi
if [ $MODE = "restore" ]
then

	query='INSERT INTO spider SET `db_name` = "'$SPIDER_NAME'"'  
	mysql -u $USER --password=$PASSWD -h $HOST scc -e "$query"
	mysql --user=$USER --password=$PASSWD -h $HOST $SPIDER_NAME < "$DUMPSDIR/$SPIDER_NAME.sql"
	mysql --user=$USER --password=$PASSWD -h $HOST $SPIDER_NAME < "$DUMPSDIR/"$SPIDER_NAME"_commands.sql"
	echo "Spider $SPIDER_NAME restored"
fi
exit 0
#EXAMPLE: ./transfer_spiders.sh [dump|restore] dump_directory localhost scc ZQLf-0.4 template_name
#EXAMPLE: ./transfer_spiders.sh [dump|restore] dump_directory host mysql_user mysql_password template_name