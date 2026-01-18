pipeline {
  agent {
    label 'kaniko-builder'
  }

  environment {
    // Datos de tu repositorio actualizados
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
        // Ejecución de Kaniko apuntando al nuevo repositorio
        sh """
          /kaniko/executor \
            --context ${WORKSPACE} \
            --dockerfile ${WORKSPACE}/Dockerfile \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${BUILD_NUMBER} \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest
        """
      }
    }

    stage('Post-Build Summary') {
      steps {
        echo "✅ Imagen construida y enviada a: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
      }
    }
  }

  post {
    success {
      echo '🚀 CI Completado con éxito en ci-builds.'
    }
    failure {
      echo '❌ Error en el Pipeline. Revisa los logs de Kaniko arriba.'
    }
  }
}