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
        // Usamos flags para que el agente no pierda la conexión por falta de CPU
        sh """
          /kaniko/executor \
            --context ${WORKSPACE} \
            --dockerfile dockerfile \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${BUILD_NUMBER} \
            --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest \
            --compressed-caching=false \
            --snapshot-mode=time \
            --use-new-run \
            --cleanup
        """
      }
    }
  }

  post {
    success {
      echo "🚀 ¡Imagen de Vocalis AI subida con éxito!"
    }
    failure {
      echo "❌ El agente de Fargate colapsó. Revisa en AWS ECS el 'Stopped Reason'."
    }
  }
}