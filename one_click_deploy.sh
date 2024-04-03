#!/bin/bash
echo "Hello World!"


# Set Env vars
if [ ! -f .env ]
then
  export $(cat .env | xargs)
fi


# Check if required tools are installed

# Check terraform version
terraform_version=$(terraform --version)
if [ $? -ne 0 ]; then
    echo "Error: Unexpected problem when checking terraform version."
    echo please check if you have the latest version of terraform installed.
    exit 1
fi

# Check mysql version
mysql_version=$(mysql --version)
if [ $? -ne 0 ]; then
    echo "Error: Unexpected problem when checking mysql client version."
    echo please check if you have the latest version of mysql client installed.
    exit 1
fi

# Check aws version
aws_version=$(aws --version)
if [ $? -ne 0 ]; then
    echo "Error: Unexpected problem when checking AWS CLI version."
    echo please check if you have the latest version of AWS CLI installed.
    exit 1
fi

# Check aws credentials
aws_credentials=$(aws sts get-caller-identity)
if [ $? -ne 0 ]; then
    echo "Error: Unexpected problem when checking AWS credentials."
    echo please run "aws configure" and input your credentials.
    exit 1
fi

# terraform init
# terraform apply -auto-approve 

DB_HOST=$(terraform output rds_endpoint | sed 's/"//g')

#mysql -u $TF_VAR_db_username -h $DB_HOST -P 3306 -D mydb -p${TF_VAR_db_password}

echo "All good" 
