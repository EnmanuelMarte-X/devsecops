pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    ECR_REPO   = '123456789012.dkr.ecr.us-east-1.amazonaws.com/devsecops'
    IMAGE_TAG  = "${GIT_COMMIT}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Security Scan (Filesystem - Trivy)') {
      steps {
        sh '''
          trivy fs --exit-code 1 --severity HIGH,CRITICAL .
        '''
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        sh '''
          /kaniko/executor \
            --context $PWD \
            --dockerfile Dockerfile \
            --destination $ECR_REPO:$IMAGE_TAG
        '''
      }
    }

    stage('Trigger Deploy to Staging') {
      steps {
        echo "Deploy triggered"
      }
    }
  }

  post {
    failure {
      echo '❌ CI falló: build detenido'
    }
  }
}
