pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "naveenkumar492/trend-app"
        DOCKER_CREDENTIALS_ID = 'dockerhub-creds'
        GITHUB_CREDENTIALS_ID = 'github-creds'
        AWS_REGION = 'us-east-1'
        EKS_CLUSTER_NAME = 'trend-cluster-new' // or use 'trend-cluster' if that's the active one
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: "${GITHUB_CREDENTIALS_ID}", url: 'https://github.com/naveen23042000/Trend.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:v1")
                }
            }
        }

        stage('Login & Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${DOCKER_IMAGE}:v1").push()
                    }
                }
            }
        }

        stage('Update Kubeconfig') {
            steps {
                sh '''
                    aws eks --region ${AWS_REGION} update-kubeconfig --name ${EKS_CLUSTER_NAME}
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    kubectl rollout status deployment/trend-app-deployment || true
                    kubectl get pods
                    kubectl get svc
                '''
            }
        }
    }

    post {
        failure {
            echo '❌ Build or deployment failed.'
        }
        success {
            echo '✅ Successfully deployed to EKS.'
        }
    }
}

