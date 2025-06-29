#!/bin/bash

: << 'COMMENT'
Django app deployment
COMMENT

code_clone() {
    echo "Cloning the django app...."
    if [ -d "/home/ec2-user/django-notes-app" ]; then
        echo "Directory already exists..."
        return 1
    else
        git clone https://github.com/LondheShubham153/django-notes-app.git /home/ec2-user/django-notes-app
    fi
}

install_requirement() {
    echo ""
    echo "Installing requirements..."
    sudo yum install docker* -y
    sudo yum install nginx -y
}

required_restart() {
    echo ""
    echo "Enabling and restarting services..."
    sudo systemctl enable docker
    sudo systemctl restart docker

    sudo systemctl enable nginx
    # sudo systemctl start nginx
}

deploy() {
    echo "Code build started..."
    cd /home/ec2-user/django-notes-app || { echo "Directory not found!"; return 1; }

    sudo docker build -t notes-app .
    sudo docker run -d -p 8000:8000 --name notes-app-container-5 notes-app:latest
    # docker-compose up -d
}

echo "********************** DEPLOYMENT STARTED ***********************************"

code_clone

if ! install_requirement; then
    echo ""
    echo "Facing issue while installing dependencies..."
    echo ""
    exit 1
fi

if ! required_restart; then
    echo ""
    echo "Facing issue while restarting services..."
    exit 1
fi

if ! deploy; then
    echo ""
    echo "Deployment failed. Please check Docker build or run errors."
    exit 1
fi

echo "****************************** DEPLOYMENT COMPLETED **********************************"

