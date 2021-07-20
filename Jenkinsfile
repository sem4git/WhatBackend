pipeline {
	agent any
    stages {
stage('SonarQube Analysis') {
	 environment {
            scannerHome = tool 'SonarScanner for MSBuild'
        }
	steps {
    withSonarQubeEnv('SonarScanner for MSBuild') {
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
