echo -e "\e[36m Disabling default mysql version \e[0m"
dnf module disable mysql -y

echo -e "\e[36m Creating mysql repo \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m Installing mysql community server \e[0m"
dnf install mysql-community-server -y

echo -e "\e[36m ENABLING MYSQL server \e[0m"
systemctl enable mysqld

echo -e "\e[36m Starting mysql server \e[0m"
systemctl start mysqld

echo -e "\e[36m setting password to mysql server \e[0m"
mysql_secure_installation --set-root-pass ExpenseApp@1