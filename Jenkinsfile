pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    AWS_ACCOUNT_ID = '001109276188'
    ECR_REPO = 'jenkins-kaniko'
    IMAGE_TAG = "${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        sh '''
          /kaniko/executor \
            --context $WORKSPACE \
            --dockerfile Dockerfile \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}
        '''
      }
    }

    stage('Trigger Deploy (dummy)') {
      steps {
        echo "Imagen ${IMAGE_TAG} subida a ECR"
      }
    }
  }

  post {
    success {
      echo '✅ Build & Push a ECR exitoso'
    }
    failure {
      echo '❌ CI falló'
    }
  }
}
