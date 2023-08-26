pipeline {
    agent any

    environment {
        KUBECONFIG_PATH = "/path/to/kubeconfig"
    }
    parameters {
        string(name: 'AWS_CREDENTIALS_ID', defaultValue: 'aws-fernando', description: 'AWS Credentials ID for ECR and other AWS services')
        string(name: 'ECR_REGISTRY', defaultValue: '443865706014.dkr.ecr.us-east-1.amazonaws.com',  description: 'ECR Registry URL')
        choice(
            choices: ['us-east-1', 'us-west-2', 'eu-west-1', 'ap-southeast-1', 'ap-northeast-1', 'Other (please specify)'],
            description: 'Choose an AWS region or select "Other" and specify your region in the text field below.',
            name: 'AWS_REGION_CHOICE'
        )
        string(
            defaultValue: '',
            description: 'If you selected "Other" above, please specify the AWS region here.',
            name: 'AWS_REGION_CUSTOM'
        )
    }

    stages {
        stage('Determine AWS Region') {
            steps {
                script {
                    AWS_REGION = (params.AWS_REGION_CHOICE == 'Other (please specify)') ? params.AWS_REGION_CUSTOM : params.AWS_REGION_CHOICE
                    env.AWS_REGION = AWS_REGION // set it as an environment variable for later use
                }
            }
        }
        stage('Compilation & Tests') {
            parallel {
                stage('Frontend Compilation & Tests') {
                    steps {
                        dir("frontend-ariane/") {
                            sh 'npm install'
                            sh 'npm test || echo "No Tests"'
                        }
                    }
                }
                stage('Backend Compilation & Tests') {
                    steps {
                        dir("backend-falcon/") {
                            sh 'go get ./...'
                            sh 'go test ./... || echo "No Tests"' 
                        }
                    }
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "${params.AWS_CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                    sh '''
                    echo ${params.ECR_REGISTRY}
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${params.ECR_REGISTRY}
                    aws ecr describe-repositories --repository-names frontend-ariane --region $AWS_REGION > /dev/null 2>&1
                    if [ ${?} -ne 0 ]; then
                    aws ecr create-repository --repository-name frontend-ariane --region $AWS_REGION
                    fi
                    aws ecr describe-repositories --repository-names frontend-ariane --region $AWS_REGION > /dev/null 2>&1
                    if [ $? -ne 0 ]; then
                    aws ecr create-repository --repository-name frontend-ariane --region $AWS_REGION
                    fi
                    '''
                    }
                    // For frontend:
                    dir("frontend-ariane/") {
                        FRONTEND_VERSION = readFile('VERSION').trim()
                        FRONTEND_IMAGE = "${params.ECR_REGISTRY}/frontend-ariane:${FRONTEND_VERSION}"
                        
                        docker.build("${FRONTEND_IMAGE}").push()
                    }
                    
                    // For backend:
                    dir("backend-falcon/") {
                        BACKEND_VERSION = readFile('VERSION').trim()
                        BACKEND_IMAGE = "${params.ECR_REGISTRY}/backend-falcon:${BACKEND_VERSION}"
                        
                        docker.build("${BACKEND_IMAGE}").push()
                    }
                }
            }
        }

        stage('Deploy on Kubernetes') {
            steps {
                script {
                    withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "${params.AWS_CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        // Check if Redis app exists
                        if (sh(script: "kubectl --kubeconfig ${KUBECONFIG_PATH} get deployments | grep redis-app", returnStatus: true) != 0) {
                            // If not, run the Redis Dockerfile
                            dir("redis/") {
                                docker.build('redis-image').push()
                            }
                            sh "kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f redis/kubernetes-deployment.yaml"
                        }

                        // Frontend Deployment
                        sh "kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f frontend/kubernetes-deployment.yaml"
                        // Backend Deployment with version handling
                        sh "kubectl --kubeconfig ${KUBECONFIG_PATH} set image deployment/backend-deployment backend=${BACKEND_IMAGE_VERSION}"
                    }
                }
            }
        }
        
        stage('Rollback Option') {
            steps {
                script {
                    def userInput = input message: 'Do you want to rollback?', 
                                        parameters: [
                                            choice(choices: ['No', 'Frontend', 'Backend', 'Both'], 
                                                    description: 'Select which deployment to rollback?', 
                                                    name: 'rollbackChoice')
                                        ]
                    
                    // If confirmed, rollback based on choice
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'your-aws-credentials-id']]) {
                        if (userInput == 'Frontend' || userInput == 'Both') {
                            // Rollback frontend to a previous version, say v1
                            def FRONTEND_OLD_IMAGE = "${params.ECR_REGISTRY}/frontend-ariane:v1"
                            sh "sed -i 's|${params.ECR_REGISTRY}/frontend-ariane:.*|${FRONTEND_OLD_IMAGE}|' frontend-ariane/kubernetes-deployment.yaml"
                            sh "kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f frontend-ariane/kubernetes-deployment.yaml"
                        }
                        
                        if (userInput == 'Backend' || userInput == 'Both') {
                            // Rollback backend to a previous version, say v1
                            def BACKEND_OLD_IMAGE = "${params.ECR_REGISTRY}/backend-falcon:v1"
                            sh "sed -i 's|${params.ECR_REGISTRY}/backend-falcon:.*|${BACKEND_OLD_IMAGE}|' backend-falcon/kubernetes-deployment.yaml"
                            sh "kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f backend-falcon/kubernetes-deployment.yaml"
                        }
                    }
                }
            }
        }
    }
}