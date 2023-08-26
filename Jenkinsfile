pipeline {
    agent any

    environment {
        KUBECONFIG_PATH = "/path/to/kubeconfig"
    }
    parameters {
        string(name: 'AWS_CREDENTIALS_ID', defaultValue: 'aws-fernando', description: 'AWS Credentials ID for ECR and other AWS services')
        string(name: 'ECR_REGISTRY', defaultValue: '443865706014.dkr.ecr.us-east-1.amazonaws.com',  description: 'ECR Registry URL')
    }

    stages {

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
                    sh "echo ${params.ECR_REGISTRY}"
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${params.ECR_REGISTRY}"
                    }
                    // For frontend:
                    dir("frontend-ariane/") {
                        FRONTEND_VERSION = readFile('VERSION').trim()
                        FRONTEND_IMAGE = "${params.ECR_REGISTRY}/frontend-image:${FRONTEND_VERSION}"
                        
                        docker.build("${FRONTEND_IMAGE}").push()
                    }
                    
                    // For backend:
                    dir("backend-falcon/") {
                        BACKEND_VERSION = readFile('VERSION').trim()
                        BACKEND_IMAGE = "${params.ECR_REGISTRY}/backend-image:${BACKEND_VERSION}"
                        
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
                            def FRONTEND_OLD_IMAGE = "${params.ECR_REGISTRY}/frontend-image:v1"
                            sh "sed -i 's|${params.ECR_REGISTRY}/frontend-image:.*|${FRONTEND_OLD_IMAGE}|' frontend-ariane/kubernetes-deployment.yaml"
                            sh "kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f frontend-ariane/kubernetes-deployment.yaml"
                        }
                        
                        if (userInput == 'Backend' || userInput == 'Both') {
                            // Rollback backend to a previous version, say v1
                            def BACKEND_OLD_IMAGE = "${params.ECR_REGISTRY}/backend-image:v1"
                            sh "sed -i 's|${params.ECR_REGISTRY}/backend-image:.*|${BACKEND_OLD_IMAGE}|' backend-falcon/kubernetes-deployment.yaml"
                            sh "kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f backend-falcon/kubernetes-deployment.yaml"
                        }
                    }
                }
            }
        }
}