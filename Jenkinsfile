pipeline {
    agent none
    stages {
        stage('Terraform Init and Apply') {
            agent { label 'IAC' }
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Retrieve Public IP') {
            agent { label 'IAC' }
            steps {
                script {
                    // Fetch the public IP from Terraform output
                    def publicIp = sh(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
                    // Store the public IP in an environment variable to pass to the Ansible stage
                    env.INSTANCE_PUBLIC_IP = publicIp
                }
            }
        }
        stage('Ansible Deployment') {
            agent { label 'CMT' } // Ansible node
            steps {
                dir('ansible') {
                    script {
                        // Write the public IP to the Ansible inventory file
                        writeFile file: 'inventory/hosts.ini', text: "[app]\n${env.INSTANCE_PUBLIC_IP}"
                    }
                    // Run the Ansible playbook using the dynamically created inventory
                    sh 'ansible-playbook -i inventory/hosts.ini playbooks/deploy.yml'
                }
            }
        }
    }
}
