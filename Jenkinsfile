pipeline {
    agent any
    tools {
        jdk 'jdk11'
        maven 'maven3'
            }
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('CODE CLONE') {
            steps {
                git branch: 'dev', credentialsId: 'ba67893d-87cc-401c-a8b7-f076395e0c8d', url: 'https://github.com/krsanjitdas/CIandCD.git'
            }
        }
        stage('CODE COMPILE') {
            steps {
                sh 'mvn clean compile'
            }
        }
         stage('CODE ANALYSIS') {
            steps {
                withSonarQubeEnv('sonar-scanner') {
                sh '$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Development -Dsonar.java.binaries=. -Dsonar.projectKey=Development'
                }
            }
        }
        stage('TRIVY SCAN') {
            steps {
                sh 'trivy fs --security-checks vuln,config $WORKSPACE'
            }
        }
        stage('CODE BUILD') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('DOCKER BUILD') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'ff598eda-51a0-4c36-aec0-f780267b2dd3', toolName: 'docker-latest') {
                      sh 'docker build -t $JOB_NAME .'
                      }
                }
            }
        }
        stage('DOCKER PUSH') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'ff598eda-51a0-4c36-aec0-f780267b2dd3', toolName: 'docker-latest') {
                      sh 'docker tag $JOB_NAME krsanjitdas/$JOB_NAME:$BUILD_NUMBER'
                      sh 'docker push krsanjitdas/$JOB_NAME:$BUILD_NUMBER'
                      }
                }
            }
        }
    }
   post {
        changed {
            script {
                if (currentBuild.currentResult == 'FAILURE') { // Other values: SUCCESS, UNSTABLE
                    // Send an email only if the build status has changed from green/unstable to red
                    emailext subject: '$DEFAULT_SUBJECT',
                        body: '$DEFAULT_CONTENT',
                        recipientProviders: [
                            [$class: 'CulpritsRecipientProvider'],
                            [$class: 'DevelopersRecipientProvider'],
                            [$class: 'RequesterRecipientProvider']
                        ], 
                        replyTo: '$DEFAULT_REPLYTO',
                        to: '$DEFAULT_RECIPIENTS'
                }
            }
        }
    }
}
