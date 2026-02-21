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
        stage('terraform-init&apply'){
            when {
                expression { params.ACTION == 'apply' }
            }
            steps{
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan'
                    sh "terraform apply --auto-approve"
                }
            }
        }
        stage('get ec2 public ip'){
            when {
                expression { params.ACTION == 'apply' }
            }
            steps{
                script {
                    env.EC2_PUBLIC_IP = sh(script: "cd terraform && terraform output -raw publicip", returnStdout: true).trim()
                    echo "EC2 Public IP: ${env.EC2_PUBLIC_IP}"
                }
            }
        }
        stage('deploy application'){
            when {
                expression { params.ACTION == 'apply' }
            }
            steps{
                
             sh """
                ssh -o StrictHostKeyChecking=no -i devops ubuntu@${env.EC2_PUBLIC_IP},
                docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER},
                docker run --name speed -d -p 8080:8080 ${DOCKER_IMAGE}:${BUILD_NUMBER} """
            }
        }
        stage('terraform-destroy'){
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps{
                dir('terraform') {
                    sh "terraform destroy --auto-approve"
                }
            }
        }
    }
}