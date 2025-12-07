pipeline {
  agent {
    docker {
      image 'sudhinms/jenkins-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  environment {
    IMAGE_REPO = "sudhinms/config-app"
  }

  stages {
    stage('Checkout') {
      steps {
        // If job SCM is configured in Jenkins UI use: checkout scm
        git branch: 'main', url: 'https://github.com/sudhinms/q_config.git'
      }
    }

    stage('Build') {
      steps {
        sh 'mvn -B clean package'
      }
    }

    stage('Build & Push Docker Image') {
      steps {
        script {
          IMAGE_TAG = "${BUILD_NUMBER}"
          FULL_IMAGE = "${IMAGE_REPO}:${IMAGE_TAG}:${BUILD_NUMBER}"

          // Build
          sh "docker build -t ${FULL_IMAGE} ."

          // Push using Jenkins-stored Docker Hub creds (username/password)
          docker.withRegistry('https://index.docker.io/v1/', 'docker-registry-cred-id') {
            docker.image(FULL_IMAGE).push()
          }

          // Cleanup local images to free space
          sh "docker rmi ${FULL_IMAGE} || true"
        }
      }
    }
  }

  post {
    success { echo "Pipeline succeeded - pushed ${FULL_IMAGE}" }
    failure { echo "Pipeline failed." }
    always  { echo "Pipeline completed." }
  }
}
