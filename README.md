# **Terraform AWS Project**

This project uses Terraform to provision and manage resources on AWS to deploy a *finapp* that uses ChatGPT. The architecture of the project is broken down into modules for managing different resources like ECS, RDS, VPC, etc. for better organization and reusability.

## **Project Directory Structure**

- `main.tf` - The main entry point for Terraform, where all the modules are used.
- `variables.tf` - Contains the declarations for variables used throughout the project.
- `outputs.tf` - Contains the outputs of the deployed resources.
- `modules/` - A directory that contains all the Terraform modules used in the project. There are different modules for each type of resource, such as ECS, Apps, RDS, VPC, etc.

## **Prerequisites**

1. You'll need to have [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
2. An [AWS account](https://portal.aws.amazon.com/billing/signup#/start) is required. Make sure your AWS credentials are configured on your local machine, or use AWS roles and policies if you're running Terraform on an EC2 instance.
    1. Make sure you have appropriate permissions to create and manage the AWS resources described in the Terraform configuration files.
3. Install and configure the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
4. Install MySQL client for your OS.
5. Generate [openai api keys](https://www.howtogeek.com/885918/how-to-get-an-openai-api-key/).

## **Getting Started - Beginner mode**

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repository to your local machine using Git.
    1. [terraform_ecs_app](https://github.com/fernandoing/terraform_ecs_app)
2.  Move into the project's root directory:
    
    ```bash
    cd /path/to/project/terraform_ecs_app
    ```
    
3. Create a `.env` file and populate it with the following values:
    
    ```bash
    TF_VAR_db_username=myuser #This is the user for the mysql instance that will be created
    TF_VAR_db_password=mypassword #This is the password for the mysql instance that will be created
    TF_VAR_jwt_key=mypassword #This key will be used for encrypting other secrets
    TF_VAR_gpt_key=my-openai-api-key #This key is for interacting with the openAIs chatgpt3.5-turbo
    ```
    
4. Provide execution permissions and run the **one click deploy** script.
    
    ```bash
    chmod u+x one_click_deploy.sh
    ./one_click_deploy.sh 
    ```
    
    This will initialize your Terraform workspace, which will download the provider plugins for AWS and will execute the terraform apply command. This should automatically provision the required infrastructure. Here is some example output:
    
    ```bash
    C02GT0L3Q05N:/Users/fernando_alcantar/project/_testing/terraform_ecs_app fernando_alcantar [sandbox]$ ./one_click_deploy.sh 
    Hello World!
    Initializing modules...
    
    Initializing the backend...
    
    Initializing provider plugins...
    - Reusing previous version of hashicorp/aws from the dependency lock file
    - Using previously-installed hashicorp/aws v5.43.0
    ...
    ...
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    application_dns = "alb-finapp-gpt-frontend-2016701622.us-east-1.elb.amazonaws.com"
    backend_dns = "alb-finapp-gpt-backend-2080820201.us-east-1.elb.amazonaws.com"
    ecs_cluster_id = "arn:aws:ecs:us-east-1:471112811565:cluster/finapp-cluster"
    rds_endpoint = "terraform-20240402212753522600000001.cpq6kwmsw9ui.us-east-1.rds.amazonaws.com:3306"
    All good
    ```
    

4. Verify your frontend application is up and running by copiying the application_dns from the previous output in your browser.

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/82bd811d-f886-4ebb-b766-5dd1c53f7518/ee20c81c-5157-4972-a53a-4e00b678a971/Untitled.png)

```bash
Outputs:
application_dns = "alb-frontent-1732600149.us-east-1.elb.amazonaws.com"
ecs_cluster_id = "arn:aws:ecs:us-east-1:533267318629:cluster/example-cluster"
rds_endpoint = "terraform-20240331191159247100000001.c1gywkyaw1qu.us-east-1.rds.amazonaws.com:3306"
```

## **Customizing the Deployment**

If you wish to customize the deployment, such as changing the instance types, or the number of instances, edit the respective values in the `variables.tf` found in the root directory.

## **Modules**

The `modules/` directory contains the definitions for each resource to be created. The `main.tf` in the root directory calls these modules and passes necessary variables to them.

## **Output**

The `outputs.tf` file defines the values that will be returned after `terraform apply` is successfully executed. For example, you can output the IP address or URL of a server.

That's all! If you have any trouble or further inquiries, don't hesitate to ask.
