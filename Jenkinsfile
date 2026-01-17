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
          def buildId = sh(
            script: "aws codebuild start-build --project-name ${CODEBUILD_PROJECT} --region ${AWS_REGION} --query 'build.id' --output text",
            returnStdout: true
          ).trim()

          echo "CodeBuild started: ${buildId}"

          timeout(time: 20, unit: 'MINUTES') {
            waitUntil {
              def status = sh(
                script: "aws codebuild batch-get-builds --ids ${buildId} --region ${AWS_REGION} --query 'builds[0].buildStatus' --output text",
                returnStdout: true
              ).trim()

              echo "Current CodeBuild status: ${status}"

              return (status == 'SUCCEEDED' || status == 'FAILED' || status == 'FAULT' || status == 'STOPPED')
            }
          }

          def finalStatus = sh(
            script: "aws codebuild batch-get-builds --ids ${buildId} --region ${AWS_REGION} --query 'builds[0].buildStatus' --output text",
            returnStdout: true
          ).trim()

          echo "Final CodeBuild status: ${finalStatus}"

          if (finalStatus != 'SUCCEEDED') {
            error "CodeBuild failed with status: ${finalStatus}"
          }
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
