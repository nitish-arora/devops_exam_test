pipeline {
	agent  any
	tools {
		maven 'Maven3'
		jdk 'Java'
	}
	options {
		timestamps()
		timeout(time: 1, unit: 'HOURS')
		skipDefaultCheckout()
		buildDiscarder(logRotator(daysToKeepStr: '10', numToKeepStr: '10'))
		disableConcurrentBuilds()
	}
	stages {
		stage('Checkout') {
			steps {
				echo 'getting checkout'
				checkout scm
			}
		}
		stage('Build') {
			steps {
				echo 'building'
				bat 'mvn install'
			}
		}
		stage('Unit Testing') {
			steps {
				echo 'Executing unit test cases'
				bat 'mvn test'
			}
		}
		stage('Sonar Analysis') {
			steps {
				withSonarQubeEnv('Test_Sonar') {
					echo 'running sonar analysis'
					bat 'mvn sonar:sonar'
				}
			}
		}
		stage('Upload to Artifactory') {
			steps {
				rtMavenDeployer(
					id: 'deployer',
					serverId: '123456789@artifactory',
					releaseRepo: 'try',
					snapshotRepo: 'try'
				)
				rtMavenRun (
					pom: 'pom.xml',
					goals: 'clean install',
					deployerId: 'deployer'
				)
				rtPublishBuildInfo(
					serverId: '123456789@artifactory'
				)
			}
		}
		stage('Docker Image') {
			steps{
				bat 'docker build -t nitisharora31/devops_exam_practice:%BUILD_NUMBER% --no-cache -f Dockerfile .'
			}
		}
		stage('Docker Image Push') {
			steps {
				withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'docker_password', usernameVariable: 'docker_username')]) {
					bat 'docker login -u %docker_username% -p %docker_password%'
					bat 'docker push nitisharora31/devops_exam_practice:%BUILD_NUMBER%'
				}
			}
		}
		stage('Stop and remove container') {
			steps {
				bat '(docker stop c_devops_practice || echo "No container exist with such name") && (docker rm -fv c_devops_practice || echo "No container exist with such name")'
			}
		}
		stage('Run container') {
			steps {
				bat 'docker run --name c_devops_practice -d -p 9999:8080 nitisharora31/devops_exam_practice:%BUILD_NUMBER%'
			}
		}
		stage('Helm chart deployment') {
			steps {
				bat 'kubectl create ns devops_exam_practice_%BUILD_NUMBER%'
				bat 'helm install hello-devops my-chart --set image=nitisharora31/devops_exam_practice:%BUILD_NUMBER%'
			}
		}
		
	}
	post {
		always {
			junit '**/*.xml'
		}
	}
}