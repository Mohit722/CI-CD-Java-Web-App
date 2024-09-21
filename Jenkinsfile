pipeline {
    agent none
    environment {
        TF_VAR_ami_id = 'ami-0522ab6e1ddcc7055'
        TF_VAR_instance_type = 't2.micro'
        TF_VAR_key_pair = 'devops'
        TF_VAR_security_group_id = 'sg-0a4b86efefd9999b7'
    }
    stages {
        stage('Terraform Init and Apply') {
            agent { label 'terraform-node' }
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Ansible Deployment') {
            agent { label 'ansible-node' }
            steps {
                dir('ansible') {
                    script {
                        def publicIp = sh(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
                        writeFile file: 'inventory/hosts.ini', text: "[app]\n${publicIp}"
                    }
                    sh 'ansible-playbook -i inventory/hosts.ini playbooks/deploy.yml'
                }
            }
        }
    }
}
