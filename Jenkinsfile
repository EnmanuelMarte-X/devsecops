pipeline {
  agent any

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Test & Build Image') {
      steps {
        sh 'docker build -t ci-go-example:${BUILD_NUMBER} .'
      }
    }

  }
}
