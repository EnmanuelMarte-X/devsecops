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
        // Descarga el código de tu repositorio de GitHub
        checkout scm
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        // Confirmamos visualmente los archivos antes de empezar
        sh "ls -la ${WORKSPACE}"

        // Ejecución de Kaniko con optimizaciones de memoria y red
        sh """
          /kaniko/executor \
            --context ${WORKSPACE} \
            --dockerfile dockerfile \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${BUILD_NUMBER} \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest \
            --compressed-caching=false \
            --use-new-run \
            --snapshot-mode=redo
        """
      }
    }

    stage('Post-Build Summary') {
      steps {
        echo "✅ Imagen ${BUILD_NUMBER} enviada exitosamente a ECR: ${ECR_REPO}"
      }
    }
  }

  post {
    success {
      echo '🚀 CI Completado con éxito en el repositorio ci-builds.'
    }
    failure {
      echo '❌ Error en el Pipeline. Revisa los recursos de Fargate o los permisos de IAM.'
    }
  }
}