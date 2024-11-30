pipeline {
    agent any

    environment {
        IMAGE_NAME = 'getintodevops/hellonode'  // Define the image name
        DOCKER_TLS_VERIFY = '0'  // Disable TLS verification (only for dev/test environments)
    }

    stages {
        stage('Clone repository') {
            steps {
                // Checkout code from the repository
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                script {
                    // Use the official Maven Docker image to build the application
                    sh '''
                    docker run --rm -v $PWD:/usr/src/mymaven -w /usr/src/mymaven maven:3.8.4-openjdk-17 mvn clean package -DskipTests
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh '''
                    docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Use 'withCredentials' to securely inject Docker Hub credentials
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        // Log in to Docker Hub securely
                        sh "echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the built Docker image to Docker Hub
                    sh 'docker push ${IMAGE_NAME}:${BUILD_NUMBER}'
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    // Remove the local Docker image after pushing to Docker Hub
                    sh 'docker rmi ${IMAGE_NAME}:${BUILD_NUMBER}'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
