pipeline {
	agent {
		docker {
			image 'mcr.microsoft.com/dotnet/core/sdk:3.1'
			args '--network host'
			}
		}	
    stages {
stage('SonarQube Analysis') {
	agent {
        docker {
            image 'openjdk' 
            args '-p 3000:3000 --network host' 
        }
    }
	 environment {
            scannerHome = tool 'SonarScanner for MSBuild'
        }
	steps {
    withSonarQubeEnv('sonar') {
      sh "dotnet ${scannerHome}/SonarScanner.MSBuild.dll begin /k:\"what-api\""
      sh "dotnet build CharlieBackend.Api"
      sh "dotnet ${scannerHome}/SonarScanner.MSBuild.dll end"
    }
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
