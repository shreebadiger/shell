log_file=/tmp/expense.log
color="\e[36m"

echo -e "${color}Installing nginx \e[0m"
dnf install nginx -y &>>log_file
echo $?

echo -e "${color} copying expense configuration file nginx \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>log_file
echo $?

echo -e "\e[36m Removing default nginx webpage  \e[0m"
rm -rf /usr/share/nginx/html/* &>>log_file
echo $?

echo -e "${color} Downloading application content \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip  &>>log_file
echo $?

echo -e "${color} Extracting content \e[0m" 
cd /usr/share/nginx/html &>>log_file
unzip /tmp/frontend.zip &>>log_file
echo $?

echo -e "${color} Starting nginx  \e[0m" 
systemctl enable nginx &>>log_file
systemctl restart nginx &>>log_file
echo $?