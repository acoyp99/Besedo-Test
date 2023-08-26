# Solution specification

## 1. CI/CD pipeline

To accomplish this part **Jenkins** was chosen as the CI/CD Tool and the pipeline is shown in the Jenkinsfile file. This pipeline has the next input variables to taking into account in relation on its execution:

- AWS_CREDENTIALS_ID = Is configured in the Credentials management tool on the Jenkins server
- ECR_REGISTRY = To have this is necessary (in case of does not exist) create the ECR repository with the next command `aws ecr create-repository --repository-name your-repo-name` the outpus is going to show a parameter like this [comment]: <> (123456789012.dkr.ecr.us-west-1.amazonaws.com)
