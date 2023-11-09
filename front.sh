echo -e "\e[36m Installing nginx \e[0m"
dnf install nginx -y

echo -e "\e[36m copyinf expense configuration file nginx \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf

echo -e "\e[36m Removing default nginx webpage  \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m Downloading application content \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip 

echo -e "\e[36m Extracting content \e[0m"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip

echo -e "\e[36m Starting nginx  \e[0m"
systemctl enable nginx
systemctl restart nginx