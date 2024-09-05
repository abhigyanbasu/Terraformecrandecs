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

        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/abhigyanbasu/Terraformecrandecs.git'
            }
        }

        stage('Terraform Init for ECR') {
            when {
                expression { return params.RESOURCE_TYPE == 'ECR' || params.RESOURCE_TYPE == 'Both' }
            }
            
            steps {
               script{ 
                  
                dir('terraform/ecr') {
                    sh 'terraform init'
                    
                }
            }
        }
        }

        stage('switch workspace') {
            when {
                expression { return params.RESOURCE_TYPE == 'ECR' || params.RESOURCE_TYPE == 'Both' }
            }
            
            steps {
               script{ 
                //def workspace = params.ECR_REPO_NAME
                    sh 'unset TF_WORKSPACE'
                    sh 'terraform workspace new $ECR_REPO_NAME'
                    
                }
            }
        }
        

        stage('Terraform Plan for ECR') {
            when {
                expression { return params.RESOURCE_TYPE == 'ECR' || params.RESOURCE_TYPE == 'Both' }
            }
            steps {
                dir('terraform/ecr') {
                    sh 'terraform plan -var="ecr_repo_name=$ECR_REPO_NAME" -out=tfplan-ecr'
                }
            }
        }

        stage('Terraform Apply for ECR') {
            when {
                expression { return params.RESOURCE_TYPE == 'ECR' || params.RESOURCE_TYPE == 'Both' }
            }
            steps {
                dir('terraform/ecr') {
                   script {
                        // Apply the Terraform plan for the first resource
                        input message: 'Approve Terraform Apply?'
                        sh 'terraform apply tfplan-ecr'
                    }
                }
            }
        }

        stage('Terraform Init for ECS') {
            when {
                expression { return params.RESOURCE_TYPE == 'ECS' || params.RESOURCE_TYPE == 'Both' }
            }
            steps {
                dir('terraform/ecs') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan for ECS') {
            when {
                expression { return params.RESOURCE_TYPE == 'ECS' || params.RESOURCE_TYPE == 'Both' }
            }
            steps {
                dir('terraform/ecs') {
                    sh "terraform plan -var 'ecs_cluster_name=${params.ECS_CLUSTER_NAME}' -out=tfplan-ecs"
                }
            }
        }

        stage('Terraform Apply for ECS') {
            when {
                expression { return params.RESOURCE_TYPE == 'ECS' || params.RESOURCE_TYPE == 'Both' }
            }
            steps {
                dir('terraform/ecs') {
                    script {
                        // Apply the Terraform plan for the second resource
                        input message: 'Approve Terraform Apply?'
                        sh 'terraform apply -auto-approve tfplan-ecs'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
            cleanWs()
        }

        failure {
            echo 'The build failed.'
        }

        success {
            echo 'Selected resources were created successfully!'
        }
    }
}