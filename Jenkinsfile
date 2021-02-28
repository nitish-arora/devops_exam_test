pipeline {
	agent  any
	tools {
		maven 'Maven3'
		jdk 'Java'
	}
	options {
		timestamps()
		timeout(time: 1, unit: 'HOURS')
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
					deployerId: '123456789@artifactory'
				)
				rtPublishBuildInfo(
					serverId: '123456789@artifactory'
				)
			}
		}
	}
}