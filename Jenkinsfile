pipeline {
    agent none
    // parameters {
    //     choice(name: 'ACTION', choices: ['create', 'destroy'], description: 'Choose whether to create or destroy the Terraform instance.')
    // }
    stages {
        // stage('Terraform Setup and Plan') {
        //     agent { label 'IAC' }
        //     steps {
        //         dir('terraform') {
        //             sh 'terraform init'
        //             sh 'terraform validate'
        //         }
        //     }
        // }
        // stage('Terraform Apply or Destroy') {
        //     agent { label 'IAC' }
        //     steps {
        //         dir('terraform') {
        //             script {
        //                 if (params.ACTION == 'create') {
        //                     sh 'terraform apply -auto-approve'
        //                 } else if (params.ACTION == 'destroy') {
        //                     sh 'terraform destroy -auto-approve'
        //                 } else {
        //                     error("Invalid ACTION parameter")
        //                 }
        //             }
        //         }
        //     }
        // }
        // stage('Retrieve Public IP') {
        //     agent { label 'IAC' }
        //     steps {
        //         script {
        //             // Fetch the public IP from Terraform output
        //             env.INSTANCE_PUBLIC_IP = sh(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()
        //             echo "New instance public IP: ${env.INSTANCE_PUBLIC_IP}"
        //         }
        //     }
        // }

        stage('Maven Build and Test') {
            agent { label 'CMT' } // Use a Jenkins agent with Maven installed
            steps {
                // Clone the code from the GitHub repository
                git url: 'https://github.com/Mohit722/spring-mvc-crud.git', branch: 'master' // Adjust branch as needed

                echo "Building War Component..."
                    dir("${WORKSPACE}") { // Ensure this is the correct path within the repo
                    sh 'mvn clean install'
                    
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
