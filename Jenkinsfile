pipeline {
    agent any

    environment {
        KUBECONFIG_PATH = "/path/to/kubeconfig"
    }

    stages {
        stage('Input Parameters') {
            steps {
                script {
                    def userInput = input(
                        id: 'userInput', message: 'Enter AWS and ECR details:',
                        parameters: [
                            string(defaultValue: 'aws-fernando', description: 'AWS Credentials ID', name: 'AWS_CREDENTIALS_ID'),
                            string(defaultValue: '443865706014.dkr.ecr.us-east-1.amazonaws.com', description: 'ECR Registry URL', name: 'ECR_REGISTRY')
                        ])

                    env.AWS_CREDENTIALS_ID = userInput['AWS_CREDENTIALS_ID']
                    env.ECR_REGISTRY = userInput['ECR_REGISTRY']
                }
            }
        }
        stage('Compilation & Tests') {
            parallel {
                stage('Frontend Compilation & Tests') {
                    steps {
                        dir("frontend-ariane/") {
                            sh 'npm install'
                            sh 'npm test'
                        }
                    }
                }
                stage('Backend Compilation & Tests') {
                    steps {
                        dir("backend-falcon/") {
                            sh 'go get ./...'
                            sh 'go test ./...'
                        }
                    }
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {

                    sh "$(aws ecr get-login-password --region us-east-1)"
                    
                    // For frontend:
                    dir("frontend-ariane/") {
                        FRONTEND_VERSION = readFile('VERSION').trim()
                        FRONTEND_IMAGE = "${ECR_REGISTRY}/frontend-image:${FRONTEND_VERSION}"
                        
                        docker.build("${FRONTEND_IMAGE}").push()
                    }
                    
                    // For backend:
                    dir("backend-falcon/") {
                        BACKEND_VERSION = readFile('VERSION').trim()
                        BACKEND_IMAGE = "${ECR_REGISTRY}/backend-image:${BACKEND_VERSION}"
                        
                        docker.build("${BACKEND_IMAGE}").push()
                    }
                }
            }
        }

        stage('Deploy on Kubernetes') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'your-aws-credentials-id']]) {
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
                        def FRONTEND_OLD_IMAGE = "${ECR_REGISTRY}/frontend-image:v1"
                        sh "sed -i 's|${ECR_REGISTRY}/frontend-image:.*|${FRONTEND_OLD_IMAGE}|' frontend-ariane/kubernetes-deployment.yaml"
                        sh "kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f frontend-ariane/kubernetes-deployment.yaml"
                    }
                    
                    if (userInput == 'Backend' || userInput == 'Both') {
                        // Rollback backend to a previous version, say v1
                        def BACKEND_OLD_IMAGE = "${ECR_REGISTRY}/backend-image:v1"
                        sh "sed -i 's|${ECR_REGISTRY}/backend-image:.*|${BACKEND_OLD_IMAGE}|' backend-falcon/kubernetes-deployment.yaml"
                        sh "kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f backend-falcon/kubernetes-deployment.yaml"
                    }
                }
            }
        }
    }
}
 