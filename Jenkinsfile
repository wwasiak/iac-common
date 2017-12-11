#!/usr/bin/env groovy

pipeline {
  agent any
  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '100'))
    timestamps()
    timeout(time: 1, unit: 'HOURS')
  }
  stages {
    stage('Commit stage tests') {
      steps {
        checkout scm
        sh './cd/01-verify-syntax.sh'
      }
    }
    stage ('Tests') {
      steps {
        withEnv(['http_proxy=http://web-proxy:8080', 'https_proxy=http://web-proxy:8080']) {
          dir ('.') {
            timeout(time: 1, unit: 'HOURS') {
              sh './cd/02-dry-run.sh'
              sh './cd/00-dependencies-user.sh'
              sh './cd/03-kitchen-test-docker.sh'
            }
          }
        }
      }
    }
    stage ('Results') {
      steps {
        archive '*.yaml'
        archive 'group_vars/*'
      }
    }
  }
  post {
    always {
      emailext body: '$DEFAULT_CONTENT',
        recipientProviders: [
          [$class: 'CulpritsRecipientProvider'],
          [$class: 'DevelopersRecipientProvider'],
          [$class: 'RequesterRecipientProvider']
        ],
        replyTo: '$DEFAULT_REPLYTO',
        subject: '$DEFAULT_SUBJECT',
        to: '$DEFAULT_RECIPIENTS'
    }
  }
}
