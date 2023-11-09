echo -e "\e[36m Disabling default nodejs \e[0m"
dnf module disable nodejs -y &>>/tmp/expense.log

echo -e "\e[36m Copying backend service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>/tmp/expense.log

echo -e "\e[36m Enabling nodejs required version \e[0m"
dnf module enable nodejs:18 -y &>>/tmp/expense.log

echo -e "\e[36m Installing nodejs \e[0m"
dnf install nodejs -y &>>/tmp/expense.log

echo -e "\e[36m Creating user to run application \e[0m"
useradd expense &>>/tmp/expense.log

echo -e "\e[36m Creating directory for the application \e[0m"
mkdir /app &>>/tmp/expense.log

echo -e "\e[36m Downloading file \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip  &>>/tmp/expense.log

echo -e "\e[36m Extracting the file \e[0m"
cd /app  &>>/tmp/expense.log
unzip /tmp/backend.zip &>>/tmp/expense.log

echo -e "\e[36m Installing dependencies \e[0m"
cd /app &>>/tmp/expense.log
npm install  &>>/tmp/expense.log

echo -e "\e[36m Starting backend service \e[0m"
systemctl daemon-reload &>>/tmp/expense.log
systemctl enable backend &>>/tmp/expense.log
systemctl restart backend &>>/tmp/expense.log

dnf install mysql -y &>>/tmp/expense.log

echo -e "\e[36m Loading the schema \e[0m"
mysql -h mysql-dev.sbadiger93.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>/tmp/expense.log


