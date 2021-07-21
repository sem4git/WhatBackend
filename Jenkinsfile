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
		environment {
            		scannerHome = tool 'SonarScanner for MSBuild'
        	}
		steps {
    			withSonarQubeEnv('sonar') {
				steps {
					sh "dotnet ${scannerHome}/SonarScanner.MSBuild.dll begin /k:\"what-api\""
      					sh "dotnet build CharlieBackend.Api"
      					sh "dotnet ${scannerHome}/SonarScanner.MSBuild.dll end"
				}
			}
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
			   sh "curl -v --user 'admin:zxczxc' --upload-file ./publish.tar http://nexus-loadb-27omuynaly1z-837220146.us-east-2.elb.amazonaws.com/repository/what-api/publish.tar"
		    }
	    }
    }
}
