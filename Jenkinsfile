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
    					sh "dotnet build CharlieBackend.Api"
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
			   sh 'tar czvf publish.tar ./CharlieBackend.Api/bin/Debug/netcoreapp3.1/publish/'
			    sh "curl -v --user '${nexususer}:${nexus_password}' --upload-file ./publish.tar http://nexus-loadb-27omuynaly1z-837220146.us-east-2.elb.amazonaws.com/repository/what-api/publish.tar"
		    }
	    }
    }
}
