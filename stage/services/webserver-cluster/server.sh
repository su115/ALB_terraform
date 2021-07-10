#! /bin/bash
DATA=$( ip -4 a |grep inet |cut -d ' ' -f 6)

update="None" 
#$(sudo apt update)

install="None" 
#$(sudo apt install mysql-client -y)

CODE="NONE" #"$(mysql -h ${db_address} -P ${db_port} -u ${db_username} -p${db_password} ${db_name} -e exit)"
echo "Hello, World\
	<br>DB address:	${db_address}\
	<br>DB port:	${db_port}\
	<br>\
	<br>$update\
	<br>$install\
	<br>$DATA">index.html
nohup busybox httpd -f -p ${server_port} &
