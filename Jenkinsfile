pipeline {
  // 1. Invoca al agente efímero en Fargate que configuramos
  agent {
    label 'kaniko-builder'
  }

  stages {
    stage('Checkout') {
      steps {
        // Baja el código de tu repositorio
        checkout scm
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        // 2. Ejecuta Kaniko usando las variables globales de Jenkins
        sh """
          /kaniko/executor \
            --context ${WORKSPACE} \
            --dockerfile ${WORKSPACE}/Dockerfile \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${BUILD_NUMBER} \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest
        """
      }
    }

    stage('Trigger Deploy (dummy)') {
      steps {
        echo "✅ Imagen ${BUILD_NUMBER} subida a ECR: ${ECR_REPO}"
      }
    }
  }

  post {
    success {
      echo '✅ Build & Push a ECR exitoso. ¡Vocalis AI está actualizado!'
    }
    failure {
      echo '❌ CI falló. Revisa los permisos de IAM o los logs de la tarea en ECS.'
    }
  }
}