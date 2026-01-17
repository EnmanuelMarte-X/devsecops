pipeline {
  agent any

  environment {
    IMAGE_NAME = "ci-go-example"
    REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
      }
    }

    stage('Unit Tests') {
      steps {
        sh "go test ./..."   // Cambia esto si no es Go
      }
    }

    stage('Trivy Scan') {
      steps {
        sh "trivy image ${IMAGE_NAME}:${BUILD_NUMBER}"
      }
    }

    stage('Push to ECR') {
      steps {
        withAWS(credentials: 'aws-credentials-id', region: "${AWS_REGION}") {
          sh """
            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REGISTRY}
            docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${REGISTRY}/${ECR_REPO}:${BUILD_NUMBER}
            docker push ${REGISTRY}/${ECR_REPO}:${BUILD_NUMBER}
          """
        }
      }
    }

    stage('Trigger Deploy Staging') {
      steps {
        build job: 'deploy-staging', wait: false, parameters: [
          string(name: 'IMAGE_TAG', value: "${BUILD_NUMBER}")
        ]
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
