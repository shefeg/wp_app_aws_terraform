pipeline {
    agent { dockerfile true }
    stages {
        stage('Checkout') {
            steps {
                checkout(
                    [$class: 'GitSCM',
                    branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'CleanBeforeCheckout']], submoduleCfg: [],
                    userRemoteConfigs: [[url: 'https://github.com/shefeg/wp_app_aws_terraform.git']]]
                )
            }
        }
        stage('Test') {
            steps {
                sh 'terraform --version'
            }
        }
    }
}

node {
    stage ('Container preparation') {
        checkout(
                [$class: 'GitSCM',
                branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false,
                extensions: [[$class: 'CleanBeforeCheckout']], submoduleCfg: [],
                userRemoteConfigs: [[url: 'https://github.com/shefeg/wp_app_aws_terraform.git']]]
                )
        def container = docker.build('container')
        container.inside {
            stage ('Checkout') {
                git url: 'https://github.com/shefeg/wp_app_aws_terraform.git'
            }
        
            stage ('Test Terraform') {
                sh 'terraform --version'
            }
            
            stage ('Set Terraform S3 remote state') {
                sh 'chmod 755 .circleci/circleci_init.sh && ./.circleci/circleci_init.sh'
            }
            
            stage ('Terraform Deployment') {
                sh 'terraform init && terraform apply -auto-approve'
                sh 'terraform output rds_endpoint > rds_endpoint.txt'
                sh 'terraform output ec2_endpoint > ec2_endpoint.txt'
                sh 'export EC2_HOST=`cat ec2_endpoint.txt`'
                sh 'export EC2_ID=`terraform output ec2_id`'
            }
            
        }
    }
}