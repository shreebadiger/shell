log_file=/tmp/expense.log
color="\e[35m"

echo -e "${color}Disabling default mysql version \e[0m"
dnf module disable mysql -y &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
 fi

echo -e "${color} Creating mysql repo \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
 fi


echo -e "${color} Installing mysql community server \e[0m"
dnf install mysql-community-server -y &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
 fi

echo -e "${color} ENABLING MYSQL server \e[0m"
systemctl enable mysqld &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
 fi

echo -e "${color} Starting mysql server \e[0m"
systemctl start mysqld &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
 fi

echo -e "${color} setting password to mysql \e[0m"
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$log_file
if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
 fi