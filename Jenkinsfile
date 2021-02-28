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
	}
}