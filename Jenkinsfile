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
        // Ejecución optimizada: eliminamos el cacheo comprimido para ahorrar RAM
        sh """
          /kaniko/executor \
            --context ${WORKSPACE} \
            --dockerfile dockerfile \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${BUILD_NUMBER} \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest \
            --compressed-caching=false \
            --use-new-run \
            --cleanup
        """
      }
    }
  }

  post {
    success {
      echo "🚀 ¡Vocalis AI subida con éxito a ECR!"
    }
    failure {
      echo "❌ El proceso falló. Revisa si el Task Role tiene permisos de AmazonEC2ContainerRegistryPowerUser."
    }
  }
}