pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        DOCKER_IMAGE = "my-python-app:${BUILD_NUMBER}"
        CONTAINER_NAME = "my-python-app"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    credentialsId: 'github-credentials',
                    url: 'https://github.com/shubham101314/practice-repo-13.git'
            }
        }

        stage('Get ECR Repo from Terraform') {
            steps {
                script {
                    // Assumes terraform apply has already run
                    ECR_REPO = sh(
                        script: "terraform output -raw ecr_repo_url",
                        returnStdout: true
                    ).trim()
                    echo "Using ECR Repository: ${ECR_REPO}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}", "--pull .")
                }
            }
        }

        stage('Tag Docker Image for ECR') {
            steps {
                script {
                    sh "docker tag ${DOCKER_IMAGE} ${ECR_REPO}:${BUILD_NUMBER}"
                    sh "docker tag ${DOCKER_IMAGE} ${ECR_REPO}:latest"
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REPO}
                    """
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh "docker push ${ECR_REPO}:${BUILD_NUMBER}"
                    sh "docker push ${ECR_REPO}:latest"
                }
            }
        }

        stage('Deploy Container Locally') {
            steps {
                sh """
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                docker run -d \
                  --name ${CONTAINER_NAME} \
                  --restart unless-stopped \
                  -p 5000:5000 \
                  ${ECR_REPO}:latest
                """
            }
        }

        stage('Cleanup Old Images (Optional)') {
            steps {
                sh """
                # Get all image digests sorted by pushed date
                aws ecr describe-images \
                  --repository-name \$(basename ${ECR_REPO}) \
                  --query 'sort_by(imageDetails,&imagePushedAt)[].imageDigest' \
                  --output text > all_digests.txt

                # Keep last 10 images, delete older
                total=\$(wc -l < all_digests.txt)
                if [ \$total -gt 10 ]; then
                  old_digests=\$(head -n \$((total-10)) all_digests.txt)
                  for digest in \$old_digests; do
                    aws ecr batch-delete-image --repository-name \$(basename ${ECR_REPO}) --image-ids imageDigest=\$digest
                  done
                fi
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
        always {
            cleanWs()
        }
    }
}
