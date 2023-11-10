log_file=/tmp/expense.log
color="\e[34m"

if [ -z "$1" ]; then
 echo password missing
 exit
MYSQL_ROOT_PASSWORD=$1



echo -e "${color} Disabling default nodejs \e[0m"
dnf module disable nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
 fi

echo -e "${color} Copying backend service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
 fi

echo -e "${color} Enabling nodejs required version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi

echo -e "${color} Installing nodejs \e[0m"
dnf install nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi

id expense &>>$log_file
if [ $? -ne 0 ]; then
echo -e "${color} Creating user to run application \e[0m"
useradd expense &>>$log_file
  if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
   fi
fi

if [ ! -d /app ]; then
echo -e "${color} Creating directory for the application \e[0m"
mkdir /app &>>$log_file
   if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
   fi
fi

echo -e "${color} Removing old application content \e[0m"
rm -rf /app/* &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi

echo -e "${color} Downloading file \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip  &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi


echo -e "${color} Extracting the file \e[0m"
cd /app  &>>/log_file
unzip /tmp/backend.zip &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi

echo -e "${color} Installing dependencies \e[0m"
cd /app &>>$log_file
npm install  &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi

echo -e "${color} Starting backend service \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi

dnf install mysql -y &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi

echo -e "${color} Loading the schema \e[0m"
mysql -h mysql-dev.sbadiger93.online -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
fi