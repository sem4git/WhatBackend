pipeline {
	agent any
    stages {
		stage('Build Api') {
			agent {
				docker {
					image 'mcr.microsoft.com/dotnet/core/sdk:3.1'
					args '--network host'
				}
			}
            steps {
					sh 'dotnet build CharlieBackend.Api'
				}
            }
		stage('Build Admin') {
			agent {
				docker {
					image 'mcr.microsoft.com/dotnet/core/sdk:3.1'
					args '--network host'
				}
			}
			steps {
				sh 'dotnet build CharlieBackend.AdminPanel'
			}
		}
		stage('UnitTest Api') {
			agent {
				docker {
					image 'mcr.microsoft.com/dotnet/core/sdk:3.1'
					args '--network host'
				}
			}			
			steps {
				sh 'dotnet test .'
			}
		}
	    	stage('Publish Api') {
			agent {
				docker {
					image 'mcr.microsoft.com/dotnet/core/sdk:3.1'
					args '--network host'
				}
			}			
			steps {
				sh 'dotnet pack CharlieBackend.Api'
				sh 'dotnet nuget push CharlieBackend.Api/bin/Debug/CharlieBackend.Api.1.0.0.nupkg --api-key 2221d13a-0e01-3d21-8d55-b0d40e35163a --source http://localhost:8081/repository/what-back/'
			}
		}
    }
}
