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
                    env.INSTANCE_PUBLIC_IP = sh(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
                    echo "New instance public IP: ${env.INSTANCE_PUBLIC_IP}"
                }
            }
        }
        // stage('Ansible Deployment') {
        //     agent { label 'CMT' } // Ansible node
        //     steps {
        //         dir('ansible') {
        //             // Run the Ansible playbook, passing the public IP as an extra variable
        //             sh "ansible-playbook -i 'localhost,' -c local playbooks/deploy.yml -e 'instance_ip=${env.INSTANCE_PUBLIC_IP}'"
        //         }
        //     }
        // }
    }
}
