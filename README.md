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
3. Once completed, verify the deployment in the Kubernetes cluster and the correct endpoint response with the elastic IP provided.

## Containerization

Deploy a multi-container application comprising the `Ariane` frontend, `Falcon` backend, and `Redis` using Docker and Kubernetes.

### Prerequisites

- **Docker**: Ensure [Docker](https://docs.docker.com/get-docker/) is installed.
- **Kubernetes Cluster**: Have a cluster up and `kubectl` set up.
- **Git**: For repository cloning.

#### Ariane Frontend

1. Clone the frontend repository

git clone https://github.com/slgevens/example-ariane.git
cd example-ariane

To deploy functionally this code there were some changes regarding to the backend integration due to there was not any. This can be demonstrated on the [app.js](frontend-ariane/app.js) file

2. Develop the Dockerfile Script for all apps as is shown:
   **Frontend Ariane**

```Dockerfile
FROM --platform=linux/amd64 node:14

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
# RUN npm ci --only=production
COPY . .

EXPOSE 3000

CMD [ "node", "app.js" ]
```

**Backend Falcon**

```Dockerfile
FROM --platform=linux/amd64 golang:1.19

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /backend
EXPOSE 4000

CMD ["/backend"]
```

**Redis Dockefile**

```Dockerfile
FROM --platform=linux/amd64 ubuntu:14.04
RUN apt-get update && apt-get install -y redis-server
EXPOSE 6379
ENTRYPOINT ["/usr/bin/redis-server"]
```

To accomplish properly the Dockerization there are some considerations to have:

- The platform definition is required
- The port must be taken into account for the Kubernetes part

### Kubernetes Deployment

The configuration to proceed to the deployment is shown in the next architecture where the cluster is going to be configured in **2 ec2 servers** as was required in the [Infrastructure as Code](#infrastructure-as-code) part and a **Master Node** which will manage the Kubernetes deployment.
![Alt text](assets/architecture.png)

1. **Set up an S3 bucket** to store the cluster state.
2. Configure `kops` to use the S3 bucket.
3. Create the cluster using `kops create cluster`.
4. **Edit the cluster** configuration if needed, using `kops edit cluster`.
5. Deploy the cluster using `kops update cluster --yes`.

#### Redis Deployment

Set up configurations for:

- PersistentVolume (PV), PersistentVolumeClaim (PVC), Deployment and Service
- The Service for Redis to expose it within the cluster on port 6379.

#### Falcon Backend Deployment

For the backend:

- Create a ConfigMap for varying configurations. This will contain the Redis URL for communication.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: falcon-config
data:
  REDIS_URL: "redis:6379"
```

#### Ariane Frontend Deployment

For the frontend:

- Set up Deployment and Service configurations.
- Ensure it communicates with Falcon Backend through Kubernetes Service.

### Networking

- Frontend ('Ariane') communicates with Backend ('Falcon') through a Service.
- Backend ('Falcon') communicates with 'Redis' through a Service.

### Post-deployment

1. Verify that all pods and services are running as expected using `kubectl get pods,services`.
2. Test communication between the frontend and backend to ensure that the data flow is seamless and that the backend can communicate with **Redis**.

In the kubernetes configuration there must be a `KUBECONFIG` file as is shown bellow:

```yaml
apiVersion: v1
clusters:
  - cluster:
      certificate-authority-data: BASE64_ENCODED_CA_CERT
      server: https://YOUR_ELASTIC_IP:6443
    name: my-k8s-cluster
contexts:
  - context:
      cluster: my-k8s-cluster
      user: admin
    name: admin@my-k8s-cluster
current-context: admin@my-k8s-cluster
kind: Config
preferences: {}
users:
  - name: admin
    user:
      client-certificate-data: BASE64_ENCODED_CLIENT_CERT
      client-key-data: BASE64_ENCODED_CLIENT_KEY
```

## Incident Response Scenario

For this requirement there is a drafted document in the solution folder addressed as README.md [incident-response-scenario](steps-to-solve-incident/README.md)

## Infrastructure as Code

## Troubleshooting

If you encounter any issues, please refer to the Jenkins console output for detailed logs. It provides insight into each step of the pipeline and can be invaluable for debugging.

---

For any additional queries or support, please raise an issue in this repository or contact the maintainers.

```

```
