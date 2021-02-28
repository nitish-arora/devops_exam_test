pipleline {
	agent  any
	tools {
		maven 'Maven 3'
		jdk 'Java'
	}
	options {
		timestamps()
		timeout(time: 1, unit: 'Hours')
		buildDiscarder(logRotator(daysToKeepStr: '10', numbToKeepStr: '10'))
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