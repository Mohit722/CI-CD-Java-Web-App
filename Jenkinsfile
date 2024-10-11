pipeline {
    agent none
    parameters {
        choice(name: 'ACTION', choices: ['create', 'destroy'], description: 'Choose whether to create or destroy the Terraform instance.')
    }
    stages {
        stage('Terraform Setup and Plan') {
            agent { label 'IAC' }
            when {
                expression { params.ACTION == 'create' } // Only run if ACTION is 'create'
            }
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform validate'
                }
            }
        }
        stage('Terraform Apply or Destroy') {
            agent { label 'IAC' }
            steps {
                dir('terraform') {
                    script {
                        if (params.ACTION == 'create') {
                            sh 'terraform apply -auto-approve'
                            // Retrieve the public IP immediately after applying
                            env.INSTANCE_PUBLIC_IP = sh(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
                            echo "Public IP Retrieved: ${env.INSTANCE_PUBLIC_IP}"
                        } else if (params.ACTION == 'destroy') {
                            sh 'terraform destroy -auto-approve'
                            echo "Resources destroyed successfully."
                            currentBuild.result = 'SUCCESS' // Mark the build as successful
                            return // Exit the stage and skip subsequent stages
                        } else {
                            error("Invalid ACTION parameter")
                        }
                    }
                }
            }
        }



        stage('Maven Build and Test') {
            agent { label 'CMT' } // Use a Jenkins agent with Maven installed
            steps {
                // Clone the code from the GitHub repository
                git url: 'https://github.com/Mohit722/vtdemo.git', branch: 'develop' // Adjust branch as needed

                echo "Building War Component..."
                    dir("${WORKSPACE}") { // Ensure this is the correct path within the repo
                    sh 'mvn clean install'
                    
                }
            }
        }
        
        stage('Ansible Deployment') {
            agent { label 'CMT' } // Ansible node
            steps {
                dir('ansible') {
                    // Run the Ansible playbook, passing the public IP as an extra variable                    
                    sh "ansible-playbook -i '${env.INSTANCE_PUBLIC_IP},' -u ubuntu playbooks/deploy.yml -e 'instance_ip=${env.INSTANCE_PUBLIC_IP}'"

                }
            }
        }
    }
}
