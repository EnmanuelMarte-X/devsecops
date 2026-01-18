pipeline {
  agent {
    label 'kaniko-builder'
  }

  environment {
    AWS_ACCOUNT_ID = '001109276188'
    AWS_REGION     = 'us-east-1'
    ECR_REPO       = 'ci-builds' 
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        // Confirmamos visualmente los archivos antes de empezar
        sh "ls -la ${WORKSPACE}"

        // Se usa 'dockerfile' en minúsculas para coincidir con tu repositorio
        sh """
          /kaniko/executor \
            --context ${WORKSPACE} \
            --dockerfile dockerfile \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${BUILD_NUMBER} \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest
        """
      }
    }

    stage('Post-Build Summary') {
      steps {
        echo "✅ Imagen ${BUILD_NUMBER} enviada exitosamente a ECR."
      }
    }
  }

  post {
    success {
      echo '🚀 CI Completado con éxito en el repositorio ci-builds.'
    }
    failure {
      echo '❌ Error en el Pipeline. Revisa si el archivo se llama "dockerfile" o "Dockerfile".'
    }
  }
}