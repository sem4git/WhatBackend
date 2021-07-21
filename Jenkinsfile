pipeline {
		agent {
			label 'docker-dotnet'
	}	
    stages {
stage('Build API') {
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
	    stage('Publish') {
		    steps {
			   sh 'dotnet publish CharlieBackend.Api'
		    }
	    }
    }
}
