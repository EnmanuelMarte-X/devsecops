pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    CODEBUILD_PROJECT = 'devops-project'
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Trigger CodeBuild') {
      steps {
        script {
          sh """
            aws codebuild start-build \
              --project-name ${CODEBUILD_PROJECT} \
              --region ${AWS_REGION}
          """
        }
      }
    }
  }

  post {
    success {
      echo '✅ Pipeline completed successfully'
    }
    failure {
      echo '❌ Pipeline failed — check logs'
    }
  }
}
