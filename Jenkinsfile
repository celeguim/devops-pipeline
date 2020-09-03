pipeline {
    agent any

    stages {
        stage('Compile') {
            steps {
                withMaven(maven: 'Maven_3_6_3_1') {
                    sh 'mvn clean compile'
                }
            }
        }

        stage('Tests') {
            steps {
                withMaven(maven: 'Maven_3_6_3_1') {
                    sh 'mvn test'
                }
            }
        }

        stage('Deployment') {
            steps {
                withMaven(maven: 'Maven_3_6_3_1') {
                    sh 'mvn deploy'
                }
            }
        }

    }
}