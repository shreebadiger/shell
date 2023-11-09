echo -e "\e[36m Installing nginx \e[0m"
dnf install nginx -y &>>/tmp/expense.log

echo -e "\e[36m copyinf expense configuration file nginx \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>/tmp/expense.log

echo -e "\e[36m Removing default nginx webpage  \e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/expense.log

echo -e "\e[36m Downloading application content \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip  &>>/tmp/expense.log

echo -e "\e[36m Extracting content \e[0m" &>>/tmp/expense.log
cd /usr/share/nginx/html &>>/tmp/expense.log
unzip /tmp/frontend.zip &>>/tmp/expense.log

echo -e "\e[36m Starting nginx  \e[0m" 
systemctl enable nginx &>>/tmp/expense.log
systemctl restart nginx &>>/tmp/expense.log