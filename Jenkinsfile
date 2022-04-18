pipeline {
    agent none
    environment {
        deploy_tag = '1.0.0'
        profile='dev'
    }
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                sh 'mvn clean install -DskipTests=true -P${profile} \
                && mvn clean'
            }
        }
        stage('Deploy') {
            agent any
            steps {
                sh 'sh deploy_docker.sh restart ${deploy_tag} ${profile}'
            }
        }
        stage('Push') {
            agent any
            steps {
                sh 'sh deploy_docker.sh push ${deploy_tag} ${profile}'
            }
        }
    }
}
