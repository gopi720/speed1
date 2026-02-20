pipeline{
    agent {
        label 'slave1'
    }
    tools{
        maven 'maven'
    }
    parameters{
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'choose terraform action'
        )
    }
    environment{
        DOCKER_IMAGE = 'gopi1996/demo_project'
    }
    stages{
        stage('checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/gopi720/speed1.git'
            }
        }
        stage('build'){
            when {
                expression { params.ACTION == 'apply' }
            }
            steps{
                sh 'mvn clean verify'
            }
        }
        stage('sonarqube-analysis'){
            when {
                expression { params.ACTION == 'apply' }
            }
            steps{
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('quality-gate'){
            when {
                expression { params.ACTION == 'apply' }
            }
            steps{
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('docker-image-build'){
            when {
                expression { params.ACTION == 'apply' }
            }
            steps{
            sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
            }
        }
        stage('docker-image-push'){
            when {
                expression { params.ACTION == 'apply' }
            }
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                }
            }
        }
    }
}