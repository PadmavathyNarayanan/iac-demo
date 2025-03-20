pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "app:latest"
        DOCKER_REPO = "paddy1123/iac-tf-app"
        KUBE_NAMESPACE = "default"
    }

    stages {
        stage('Checkout') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-padma', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    git url: "https://$GIT_USER:$GIT_TOKEN@github.com/PadmavathyNarayanan/iac-demo.git", branch: 'main'
                }
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
                sh 'mv target/*.jar target/myapp.jar'  // Rename JAR
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                                  usernameVariable: 'DOCKER_USER', 
                                  passwordVariable: 'DOCKER_PASSWORD')]) {
    sh 'echo $DOCKER_PASSWORD | docker login -u "$DOCKER_USER" --password-stdin'
    sh 'docker tag $DOCKER_IMAGE $DOCKER_REPO:latest'
    sh 'docker push $DOCKER_REPO:latest'
}

            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
            }
        }
    }
}
