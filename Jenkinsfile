pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    AWS_ACCOUNT_ID = '001109276188'
    IMAGE_NAME = 'ci-go-example'
    ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/devsecops/ci-go-example"
    IMAGE_TAG = "${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Image (with Tests)') {
      steps {
        sh """
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
        """
      }
    }

    stage('Security Scan (Trivy)') {
      steps {
        sh """
          trivy image \
            --config security/trivy.yaml \
            --output trivy-report.txt \
            ${IMAGE_NAME}:${IMAGE_TAG}
        """
      }
      post {
        always {
          archiveArtifacts artifacts: 'trivy-report.txt', allowEmptyArchive: true
        }
      }
    }

    stage('Login to ECR') {
      steps {
        withCredentials([
          string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh """
            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
            export AWS_DEFAULT_REGION=${AWS_REGION}

            aws ecr get-login-password --region ${AWS_REGION} |
            docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
          """
        }
      }
    }

    stage('Tag Image for ECR') {
      steps {
        sh """
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
        """
      }
    }

    stage('Push Image to ECR') {
      steps {
        sh """
          docker push ${ECR_REPO}:${IMAGE_TAG}
        """
      }
    }
  }

  post {
    success {
      echo '✅ Pipeline completed successfully and image pushed to ECR'
    }
    failure {
      echo '❌ Pipeline failed — check logs'
    }
  }
}
