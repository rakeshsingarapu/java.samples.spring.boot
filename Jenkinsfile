node {
    def app

    environment {
        DOCKER_TLS_VERIFY = '0'  // Disable TLS verification (only for dev/test environments)
    }

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    /*
    stage('Build image') {
        //This builds the actual image; synonymous to
         // docker build on the command line 

        script {
                    // Running 'ls' inside a shell
                    sh 'pwd'
                    sh 'ls'
                    sh 'mvn clean package -DskipTests'

                    sh '''
                    docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                    '''
                }
    }*/
    
    stage('Build with Maven') {
        steps {
            script {
                // Use the official Maven Docker image to run Maven build
                sh 'docker run --rm -v $PWD:/usr/src/mymaven -w /usr/src/mymaven maven:3.8.4-openjdk-17 mvn clean package -DskipTests'
            }
        }
    }

   stage('Login to Docker Hub') {
        steps {
            script {
                // Log in to Docker Hub using the credentials
                sh "echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin"
            }
        }
    }

    stage('Push Docker Image') {
        steps {
            script {
                // Push the image to Docker Hub
                sh 'docker push ${IMAGE_NAME}:${BUILD_NUMBER}'
            }
        }
    }

    stage('Clean Up') {
        steps {
            script {
                // Remove the local Docker image after pushing
                sh 'docker rmi ${IMAGE_NAME}:${BUILD_NUMBER}'
            }
        }
    }
}