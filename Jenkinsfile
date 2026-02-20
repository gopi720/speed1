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
    }
}