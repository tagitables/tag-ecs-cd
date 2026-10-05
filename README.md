AWS Cloud Infrastructure Engineering - Coaching 17

This project implements continuous deployment of a containerized Flask
application to Amazon ECS and Amazon ECR using Terraform and GitHub Actions.

## Status

Completed.

The project successfully implements continuous deployment of a
containerized Flask application to Amazon ECS Fargate.

### Deployment Flow

GitHub
→ GitHub Actions
→ Docker Build
→ Amazon ECR
→ ECS Task Definition
→ Amazon ECS Fargate
→ Flask Application

### AWS Resources

- Region: us-east-1
- ECR Repository: tag-flask-dev-ecr
- ECS Cluster: tag-flask-dev-ecs
- ECS Service: tag-flask-dev-service
- Container: tag-flask-dev-container
- Application Port: 8080

### Validation

- Terraform infrastructure deployment: Successful
- Docker image build: Successful
- Amazon ECR push: Successful
- ECS Fargate task: Running
- Flask application endpoint: Successful
- Health endpoint: Successful
- GitHub Actions continuous deployment: Successful
