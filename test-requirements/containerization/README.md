# devops.technical-tests.containerization

Containerize the provided application using Docker:
  - For the given application with a frontend (`Ariane`), a backend (`Falcon`) and a Redis (`redis`), create Dockerfiles for each component.
    - Ariane code repository: github.com/slgevens/example-ariane
    - Falcon code repository: github.com/slgevens/example-falcon
    - Redis must use port `6379`
  - Subsequently, write a Kubernetes deployment configuration to manage this multi-container application. 
    - It should include the following requirements:
        - Containers: Create Kubernetes Deployments for frontend, backend, and Redis. They should each have their own Deployment and be exposed with their own Service.
        - Networking: The frontend should communicate with the backend through a Service, and the backend should communicate with Redis in a similar manner.
        - ConfigMap/Secrets: Use a ConfigMap for any configuration that might vary between environments.
        - Persistence: Use a PersistentVolume and PersistentVolumeClaim to store data of Redis.
