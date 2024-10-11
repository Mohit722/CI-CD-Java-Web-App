# Project Title: Automated Java Application Deployment with Terraform, Ansible, and Jenkins

## Overview

This project aims to automate the end-to-end deployment of a Java web application using a combination of Terraform, Ansible, and Jenkins. It simplifies the process of setting up the necessary infrastructure, configuring the environment, and deploying the application, thereby reducing the potential for human error and increasing deployment speed.

### Key Components:

- Terraform: A powerful Infrastructure as Code (IaC) tool that allows you to define and manage infrastructure resources in a declarative manner. In this project, Terraform provisions an AWS EC2 instance, configures security groups, and installs required software such as JDK 11 and Jetty server through provisioners.

- Ansible: A robust configuration management tool that automates the deployment process. Ansible is used to copy the built Java application (in the form of a WAR file) to the newly created EC2 instance and ensures that the Jetty server is properly configured and restarted to serve the application.

- Jenkins: A continuous integration and continuous delivery (CI/CD) platform that automates the process of building, testing, and deploying applications. In this project, Jenkins orchestrates the entire workflow: it initiates the Terraform process, builds the Java application using Maven, and runs the Ansible playbook to deploy the application.

### Workflow:

1. Infrastructure Provisioning: The user initiates a pipeline in Jenkins, which triggers Terraform to create a new EC2 instance on AWS. This instance is set up with the necessary security group configurations to allow external access.

2. Application Build: Once the infrastructure is in place, Jenkins builds the Java application using Maven, which produces a WAR file.

3. Application Deployment: Jenkins invokes Ansible to deploy the WAR file to the Jetty server running on the newly created EC2 instance. Ansible also takes care of restarting the Jetty server to ensure that the application is available.

4. Accessing the Application: After deployment, the public IP of the EC2 instance is provided, allowing users to access the web application via their browser.

### Benefits:

- Automation: Reduces manual intervention in the deployment process, leading to faster and more reliable deployments.
- Scalability: Easily scalable infrastructure, as Terraform configurations can be adjusted to create multiple instances or change instance types.
- Consistency: Ensures consistent environments by using version-controlled scripts for both infrastructure and application deployment.

This project serves as a practical example of modern DevOps practices, showcasing how to leverage popular tools to create a robust and automated deployment pipeline for Java applications.

## Technologies Used

- Terraform: Infrastructure as Code (IaC) for provisioning AWS resources.
- Ansible: Configuration management and deployment of the application.
- Jenkins: Continuous integration and automation of the build and deployment pipeline.
- Maven: Build tool for Java applications.
- Java: Programming language used for the web application.
- Jetty: Java-based web server for serving the application.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- An AWS account with permissions to create EC2 instances and security groups.
- Terraform installed on your local machine or Jenkins server.
- Ansible installed on your Ansible controller node.
- Jenkins installed and running with necessary plugins.
- Maven installed on the Jenkins node where the build will take place.

## Project Structure

```
/project-root
├── terraform/
│   ├── main.tf          # Terraform configuration for provisioning AWS resources
├── ansible/
│   ├── playbooks/
│       ├── deploy.yml   # Ansible playbook to deploy the application
├── Jenkinsfile          # Jenkins pipeline definition
├── README.md            # Project documentation
```

## Getting Started

### Step 1: Configure Terraform

1. Navigate to the `terraform` directory.
2. Update the `main.tf` file to specify your desired configurations (AWS region, instance type, security groups, etc.).

### Step 2: Configure Ansible

1. In the `ansible/playbooks` directory, update the `deploy.yml` playbook if necessary. This playbook is responsible for copying the WAR file and restarting the Jetty server on the provisioned instance.

### Step 3: Create Jenkins Pipeline

1. Create a new pipeline job in Jenkins.
2. Point the job to your GitHub repository containing the `Jenkinsfile`.
3. Set the pipeline parameters:
   - `ACTION`: Choose between `create` and `destroy` to manage the infrastructure.

### Step 4: Run the Pipeline

1. If you choose `create`, the pipeline will:
   - Execute Terraform to create a new EC2 instance.
   - Install JDK 11 and Jetty on the new instance using Terraform provisioners.
   - Use Maven to build the Java application and generate a WAR file.
   - Run the Ansible playbook to deploy the WAR file to the Jetty server on the new instance.
   - Provide the public IP of the instance to access the application.

2. If you choose `destroy`, the pipeline will:
   - Execute Terraform to destroy the provisioned EC2 instance and associated resources.
   - Skip subsequent stages.

## Accessing the Application

Once the pipeline successfully completes the `create` action, you can access the deployed application by navigating to:

```
http://<public_ip>:8080/<context_path>
```

Replace `<public_ip>` with the public IP provided by the pipeline, and `<context_path>` with the context path of your application (e.g., `/SpringMVCCCRUDApp`).

## Troubleshooting

- HTTP Error 500: This error often occurs due to database connectivity issues. Ensure that the database is accessible from the EC2 instance and that the correct credentials are being used in the application.
- WAR file not found: Check the Ansible playbook to ensure the WAR file path is correct, and verify that the file was built successfully by Maven.

## Conclusion

This project provides a comprehensive CI/CD pipeline that automates the deployment of a Java web application using modern DevOps practices. It can be easily extended and modified to accommodate different applications and infrastructure requirements.

## License

This project is licensed under the MIT License.


