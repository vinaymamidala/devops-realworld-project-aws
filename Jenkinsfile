pipeline {
    agent any

    environment {
        TF_VERSION = "1.6.6"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                terraform --version
                terraform init -input=false
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh 'terraform plan -var="env=dev" -out=tfplan'
                    } else if (env.BRANCH_NAME == 'staging') {
                        sh 'terraform plan -var="env=staging" -out=tfplan'
                    } else if (env.BRANCH_NAME == 'main') {
                        sh 'terraform plan -var="env=prod" -out=tfplan'
                    } else {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'staging'
                    branch 'main'
                }
            }
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh 'terraform apply -auto-approve tfplan'
                    } else if (env.BRANCH_NAME == 'staging') {
                        sh 'terraform apply -auto-approve tfplan'
                    } else if (env.BRANCH_NAME == 'main') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/tfplan', fingerprint: true
        }
        failure {
            echo "Terraform pipeline failed on branch ${env.BRANCH_NAME}"
        }
    }
}