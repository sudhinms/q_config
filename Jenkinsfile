pipeline {
  agent {
    docker {
      image 'sudhinms/jenkins-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  parameters {
    choice(name: 'VERSION', choices: ['1.1.0', '1.1.1', '1.1.2'], description: 'Version to deploy')
    booleanParam(name: 'executeTests', defaultValue: false, description: 'Run tests?')  }

  environment {
    IMAGE_REPO = "sudhinms/quiz-config-app"
  }

  stages {
    stage('Checkout') {
      steps {
        echo "Selected version ${params.VERSION}"
        git branch: 'main', url: 'https://github.com/sudhinms/q_config.git'
      }
    }

    stage('Build') {
      when {
        expression {
            (BRANCH_NAME == 'main' || BRANCH_NAME == 'master') && CODE_CHANGES == true
        }
      }
      steps {
        sh 'mvn -B clean package'
      }
    }

    stage('Test') {
          when {
            expression {
                params.executeTests == true
            }
          }
          steps {
            echo "Testing stage..."
            echo "Testing in progress..."
          }
    }

    stage('Build & Push Docker Image') {
      steps {
        script {
          IMAGE_TAG = "${BUILD_NUMBER}"
          FULL_IMAGE = "${IMAGE_REPO}:${IMAGE_TAG}"

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
    always  {
        echo "Pipeline completed."
        echo "Commit from :: ${GIT_COMMITTER_NAME} built."
        }
  }
}
