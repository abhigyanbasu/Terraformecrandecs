pipeline {
    agent any

    parameters {
        choice(
            name: 'RESOURCES',
            choices: ['ECR', 'ECS', 'Both'],
            description: 'Select the resource(s) to deploy (Resource1, Resource2, or Both).'
        )
    }

    environment {
        // Terraform workspace, if applicable
        TF_WORKSPACE = 'default'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Check out the code from the repository
                git branch: 'main', url: 'https://github.com/your-repo.git'
            }
        }

        stage('Terraform Init for Resource 1') {
            when {
                expression { return params.RESOURCES == 'Resource1' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/resource1') {  // Directory containing the Terraform configuration for the first resource
                    script {
                        // Initialize Terraform for the first resource
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan for Resource 1') {
            when {
                expression { return params.RESOURCES == 'Resource1' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/resource1') {
                    script {
                        // Plan Terraform changes for the first resource
                        sh 'terraform plan -out=tfplan1'
                    }
                }
            }
        }

        stage('Terraform Apply for Resource 1') {
            when {
                expression { return params.RESOURCES == 'Resource1' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/resource1') {
                    script {
                        // Apply the Terraform plan for the first resource
                        sh 'terraform apply -auto-approve tfplan1'
                    }
                }
            }
        }

        stage('Terraform Init for Resource 2') {
            when {
                expression { return params.RESOURCES == 'Resource2' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/resource2') {  // Directory containing the Terraform configuration for the second resource
                    script {
                        // Initialize Terraform for the second resource
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan for Resource 2') {
            when {
                expression { return params.RESOURCES == 'Resource2' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/resource2') {
                    script {
                        // Plan Terraform changes for the second resource
                        sh 'terraform plan -out=tfplan2'
                    }
                }
            }
        }

        stage('Terraform Apply for Resource 2') {
            when {
                expression { return params.RESOURCES == 'Resource2' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/resource2') {
                    script {
                        // Apply the Terraform plan for the second resource
                        sh 'terraform apply -auto-approve tfplan2'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }

        failure {
            echo 'The build failed.'
        }

        success {
            echo 'Selected resources created successfully!'
        }
    }
}