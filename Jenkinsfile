pipeline {
  // 1. Invoca al agente efímero en Fargate configurado en ITLA
  agent {
    label 'kaniko-builder'
  }

  environment {
    // Definición de variables globales para el pipeline
    AWS_ACCOUNT_ID = '001109276188'
    AWS_REGION     = 'us-east-1'
    ECR_REPO       = 'ci-builds' 
  }

  stages {
    stage('Checkout') {
      steps {
        // Baja el código de tu repositorio de GitHub
        checkout scm
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        // Debug opcional: lista los archivos para asegurar que el Dockerfile existe
        sh "ls -la ${WORKSPACE}"

        // 2. Ejecución de Kaniko con rutas corregidas
        sh """
          /kaniko/executor \
            --context ${WORKSPACE} \
            --dockerfile Dockerfile \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${BUILD_NUMBER} \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest
        """
      }
    }

    stage('Post-Build Summary') {
      steps {
        echo "✅ Imagen ${BUILD_NUMBER} subida con éxito a ECR: ${ECR_REPO}"
      }
    }
  }

  post {
    success {
      echo '🚀 CI Completado. ¡Vocalis AI está listo en ci-builds!'
    }
    failure {
      echo '❌ Error en el Pipeline. Verifica si el nombre del archivo es "Dockerfile" (mayúscula inicial).'
    }
  }
}