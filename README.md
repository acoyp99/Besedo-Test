# Technical Test Solution - Arley Coy

This repository provides solutions for the technical test, covering the following aspects:

- Containerization
- CI/CD
- Infrastructure as Code
- Provisioning
- Incident Response

Below are detailed explanations, diagrams, code examples, and steps to follow for each section.

---

## CI/CD Pipeline

This repository contains the codebase and Jenkins pipeline configuration to implement a CI/CD flow including the following stages:

- Compilation and Testing
- Building Docker images and pushing them to ECR
- Deploying the application on a Kubernetes cluster

### Prerequisites

Before you start replicating the Jenkins execution, ensure you have the following prerequisites:

1. **Jenkins**:

   - Install Jenkins on a server or local machine. [Official Jenkins Installation Guide](https://www.jenkins.io/doc/book/installing/)
   - Ensure you have the required plugins installed:
     - Docker Pipeline
     - Kubernetes Continuous Deploy
     - Amazon ECR
     - AWS Steps
     - Pipeline

2. **AWS Account**:

   - You need an active AWS account.
   - Set up AWS CLI with the required permissions. [AWS CLI Setup Guide](https://aws.amazon.com/cli/)

3. **Kubernetes Cluster**:

   - Have a running Kubernetes cluster.
   - `kubectl` command-line tool installed and configured to interact with your cluster.

4. **Docker**:
   - Ensure Docker is installed on the machine where Jenkins is running. [Docker Installation Guide](https://docs.docker.com/get-docker/)

### Pipeline Overview

1. **Compilation and Test**:

   - The code is compiled.
   - Tests are executed to ensure functionality.

2. **Docker Build and Push**:

   - Docker images are built from the codebase.
   - Images are pushed to Amazon Elastic Container Registry (ECR).

3. **Deploy with Kubernetes**:
   - The application is deployed to a Kubernetes cluster using the images in ECR.

### Configurations Needed to Replicate Jenkins Execution

1. **Jenkins Configuration**:

   - Set up your Jenkins to have the required environment variables, namely `AWS_CREDENTIALS_ID` and `ECR_REGISTRY`.
   - Add your AWS credentials in Jenkins credentials manager with the ID `AWS_CREDENTIALS_ID`.

2. **Pipeline Configuration**:

   - In the Jenkins dashboard, create a new pipeline job.
   - Point it to the `Jenkinsfile` in this repository.
   - When prompted, provide the required parameters (`AWS_REGION_CHOICE`, `AWS_REGION_CUSTOM`).

3. **AWS Configuration**:

   - Ensure the ECR repository exists. The Jenkins pipeline will attempt to create it if it doesn't.
   - Ensure your AWS user has permissions for ECR and other necessary AWS services.

4. **Kubernetes Configuration**:
   - Ensure your `kubectl` is set up correctly to point to your cluster.
   - Store your kubeconfig in a location that Jenkins can access, and update the `KUBECONFIG_PATH` environment variable in the `Jenkinsfile` accordingly.

### Execution

Once all configurations are in place:

1. Trigger the Jenkins pipeline either by a push to the repository or manually via the Jenkins dashboard.
2. Monitor the pipeline's progress in the Jenkins dashboard.
3. Once completed, verify the deployment in your Kubernetes cluster.

## Troubleshooting

If you encounter any issues, please refer to the Jenkins console output for detailed logs. It provides insight into each step of the pipeline and can be invaluable for debugging.

---

For any additional queries or support, please raise an issue in this repository or contact the maintainers.
