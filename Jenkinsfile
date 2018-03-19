node {
    parameters {
        choice(choices: 'dev\nprod', description: 'What Wokspace?', name: 'WORKSPACE')
    }
    stage ('Container preparation') {
        checkout(
                [$class: 'GitSCM',
                branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false,
                extensions: [[$class: 'CleanBeforeCheckout']], submoduleCfg: [],
                userRemoteConfigs: [[url: 'https://github.com/shefeg/wp_app_aws_terraform.git']]]
                )
        // def container = docker.build('container')
        def container = docker.build('container', '-f Dockerfile_data .')
        container.inside {
            stage ('Checkout') {
                git url: 'https://github.com/shefeg/wp_app_aws_terraform.git'
            }
        
            stage ('Test Terraform') {
                sh 'terraform --version && terraform validate && terraform plan'
            }
            
            stage ('Terraform Deployment') {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh """
                        chmod 755 .circleci/circleci_init.sh && ./.circleci/circleci_init.sh
                        terraform init && terraform workspace new ${params.WORKSPACE} || terraform workspace select ${params.WORKSPACE}
                        terraform apply -auto-approve
                        terraform output rds_endpoint > rds_endpoint.txt
                        terraform output ec2_endpoint > ec2_endpoint.txt
                        aws s3 cp s3://${BUCKET}/env:/${params.WORKSPACE}/terraform.tfstate target/${params.WORKSPACE}-terraform.tfstate
                    """
                    env.EC2_HOST=sh(returnStdout: true, script: 'cat ec2_endpoint.txt').trim()
                    env.EC2_ID=sh(returnStdout: true, script: 'terraform output ec2_id').trim()
                }
                archive 'target/*.tfstate'
            }
                
            stage ('Chef Deployment') {
                withCredentials([string(credentialsId: 'chef_key', variable: 'KEY')]) {
                    sh "echo ${KEY} > key"
                }
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh """#!/bin/bash
                        while ! [[ `aws ec2 describe-instance-status --instance-ids ${EC2_ID} --query 'InstanceStatuses[*].[InstanceStatus]' --region ${REGION}` = *"passed"* ]]; do \
                        echo \"Wait for Reachability Check to pass...\"; sleep 10; done
                    """
                    timeout(time: 60, unit: 'SECONDS') {
                        sshagent(['ec2_user_key']) {
                            sh """
                                while ! scp -o StrictHostKeyChecking=no *endpoint.txt key chef_commands.sh ${USER}@${EC2_HOST}:/tmp; do \
                                echo \"SSH failed, retrying... \"; sleep 10; done
                                ssh -o StrictHostKeyChecking=no ${USER}@${EC2_HOST} 'cd /tmp; chmod 755 chef_commands.sh && ./chef_commands.sh'
                            """
                        }
                    }
                }
            }
            stage ('Verify if WP app is available') {
                timeout(time: 60, unit: 'SECONDS') {
                    sh "until `curl -sS http://${EC2_HOST} > /dev/null`; do sleep 5; done"
                }
            }
        }
    }
}