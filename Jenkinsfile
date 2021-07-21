pipeline {
		agent {
			label 'docker-dotnet'
	}	
    stages {
stage('SonarQube Analysis') {
	steps {
      sh "dotnet build CharlieBackend.Api"
      }
}
		stage('Build AdminPanel') {
			steps {
				sh 'dotnet build CharlieBackend.AdminPanel'
			}
		}
		stage('UnitTest Api') {			
			steps {
				sh 'dotnet test .'
			}
		}
    }
}
