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