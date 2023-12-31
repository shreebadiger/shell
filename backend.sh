source common.sh

if [ -z "$1" ]; then
 echo password missing
 exit
fi
MYSQL_ROOT_PASSWORD=$1



echo -e "${color} Disabling default nodejs \e[0m"
dnf module disable nodejs -y &>>$log_file


echo -e "${color} Copying backend service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
status_check

echo -e "${color} Enabling required nodejs version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
status_check

echo -e "${color} Installing nodejs \e[0m"
dnf install nodejs -y &>>$log_file
status_check

id expense &>>$log_file
if [ $? -ne 0 ]; then
echo -e "${color} Creating user to run application \e[0m"
useradd expense &>>$log_file
status_check
fi

if [ ! -d /app ]; then
echo -e "${color} Creating directory for the application \e[0m"
mkdir /app &>>$log_file
status_check
fi

echo -e "${color} Removing old application content \e[0m"
rm -rf /app/* &>>$log_file
status_check

echo -e "${color} Downloading file \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip  &>>$log_file
status_check


echo -e "${color} Extracting the file \e[0m"
cd /app  &>>/log_file
unzip /tmp/backend.zip &>>$log_file
status_check

echo -e "${color} Installing dependencies \e[0m"
cd /app &>>$log_file
npm install  &>>$log_file
status_check

echo -e "${color} Starting backend service \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
status_check

dnf install mysql -y &>>$log_file
status_check

echo -e "${color} Loading the schema \e[0m"
mysql -h mysql-dev.sbadiger93.online -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql &>>$log_file
status_check