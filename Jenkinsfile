pipeline {
    agent none
    stages {
        stage('Terraform Init and Apply') {
            agent { label 'IAC' }
            steps {
                dir('terraform') {
                    sh 'terraform destory --yes'
                }
            }
        }
        stage('Ansible Deployment') {
            agent { label 'CMT' }
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
    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}
