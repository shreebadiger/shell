log_file=/tmp/expense.log
color="\e[36m"

status_check() {
  if [ $? -eq 0 ]; then
   echo -e "\e[31m Success \e[0m"
  else
    echo -e "\e[31m Failure \e[0m"
  fi

}

