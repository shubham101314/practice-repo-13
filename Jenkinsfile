pipeline {
    agent any

    environment {
        # Include Docker Hub username if pushing, otherwise keep simple
        DOCKER_IMAGE = "my-python-app:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-credentials', url: 'https://github.com/shubham101314/practice-repo-13.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using Dockerfile in repo root
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        // Optional stage if you want to push to Docker Hub
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'shubham101314') {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                # Stop previous container if exists
                docker stop my-python-app || true
                docker rm my-python-app || true

                # Run new container, matching port from Dockerfile (5000)
                docker run -d --name my-python-app --restart unless-stopped -p 5000:5000 ${DOCKER_IMAGE}
                '''
            }
        }
    }
}
