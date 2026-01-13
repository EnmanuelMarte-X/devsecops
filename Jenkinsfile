pipeline {
  agent any

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Test') {
      steps {
        sh 'docker build -t ci-go-example:${BUILD_NUMBER} .'
      }
    }

  }
}
