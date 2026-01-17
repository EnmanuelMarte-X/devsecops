pipeline {
  agent any

  environment {
    AWS_REGION     = 'us-east-1'
    AWS_ACCOUNT_ID = '001109276188'
    ECR_REPO       = 'devsecops/ci-go-example'
    IMAGE_TAG      = "${BUILD_NUMBER}"
    ECR_URI        = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Unit Tests') {
      steps {
        sh 'go test ./...'
      }
    }

    stage('Security Scan (Filesystem - Trivy)') {
      steps {
        sh '''
          trivy fs \
            --exit-code 1 \
            --severity HIGH,CRITICAL \
            .
        '''
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        sh '''
          /kaniko/executor \
            --context $WORKSPACE \
            --dockerfile $WORKSPACE/Dockerfile \
            --destination ${ECR_URI}:${IMAGE_TAG} \
            --destination ${ECR_URI}:latest
        '''
      }
    }

    stage('Trigger Deploy to Staging') {
      steps {
        build job: 'deploy-staging',
              wait: false,
              parameters: [
                string(name: 'IMAGE_TAG', value: "${IMAGE_TAG}")
              ]
      }
    }
  }

  post {
    success {
      echo '✅ CI exitoso: tests, security scan y push a ECR completados'
    }
    failure {
      echo '❌ CI falló: build detenido'
    }
  }
}
