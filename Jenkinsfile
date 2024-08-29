pipeline {
    agent any

    parameters {
        choice(
            name: 'RESOURCE_TYPE',
            choices: ['ECR', 'ECS', 'Both'],
            description: 'Select the type of resource to deploy (ECR, ECS, or Both)'
        )
        string(
            name: 'ECR_REPO_NAME',
            defaultValue: '',
            description: 'Enter the name of the ECR repository (required if ECR is selected)'
        )
        string(
            name: 'ECS_CLUSTER_NAME',
            defaultValue: '',
            description: 'Enter the name of the ECS cluster (required if ECS is selected)'
        )
    }

    environment {
        // Terraform workspace, if applicable
        TF_VERSION = "1.5.7"  // Replace with your desired Terraform version
        TF_WORKSPACE = "default"
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Validate Parameters') {
            steps {
                script {
                    if (params.RESOURCE_TYPE == 'ECR' && params.ECR_REPO_NAME == '') {
                        error('You selected ECR but did not provide an ECR repository name.')
                    }
                    if (params.RESOURCE_TYPE == 'ECS' && params.ECS_CLUSTER_NAME == '') {
                        error('You selected ECS but did not provide an ECS cluster name.')
                    }
                    if (params.RESOURCE_TYPE == 'Both' && (params.ECR_REPO_NAME == '' || params.ECS_CLUSTER_NAME == '')) {
                        error('You selected Both but did not provide both ECR repository and ECS cluster names.')
                    }
                }
            }
        }
    }
    stages {
        stage('Checkout Code') {
            steps {
                // Check out the code from the repository
                git branch: 'master', url: 'https://github.com/abhigyanbasu/Terraformecrandecs.git'
            }
        }

        stage('Terraform Init for ECR') {
            when {
                expression { return params.RESOURCES == 'ECR' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/ecr') {  // Directory containing the Terraform configuration for the first resource
                    script {
                        // Initialize Terraform for the first resource
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan for ECR') {
            when {
                expression { return params.RESOURCES == 'ECR' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/ecr') {
                    script {
                        // Plan Terraform changes for the first resource
                        def REPO_NAME = "${params.REPO_NAME}"
                        sh 'terraform plan -var="ecr_repo_name=$REPO_NAME" -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply for ECR') {
            when {
                expression { return params.RESOURCES == 'ECR' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/ecr') {
                    script {
                        // Apply the Terraform plan for the first resource
                        input message: 'Approve Terraform Apply?'
                        sh 'terraform apply tfplan'
                    }
                }
            }
        }

        stage('Terraform Init for ECS') {
            when {
                expression { return params.RESOURCES == 'ECS' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/ecs') {  // Directory containing the Terraform configuration for the second resource
                    script {
                        // Initialize Terraform for the second resource
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan for ECS') {
            when {
                expression { return params.RESOURCES == 'ECS' || params.RESOURCES == 'Both' }
            }
            steps {
                dir('terraform/ecs') {
                    script {
                        // Plan Terraform changes for the second resource
                        def CLUSTER_NAME = "${params.CLUSTER_NAME}"
                        sh 'terraform plan -var="ecs_cluster_name=$CLUSTER_NAME" -out=tfplan2'
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
                        input message: 'Approve Terraform Apply?'
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
