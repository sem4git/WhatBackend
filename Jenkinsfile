pipeline {
	agent {
		docker {
			image 'mcr.microsoft.com/dotnet/core/sdk:3.1'
			args '--network host'
			}
		}	
    stages {
		stage('Build Api') {
            steps {
					sh 'dotnet build CharlieBackend.Api'
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
	    	stage('Publish AdminPanel') {		
			steps {
				sh 'dotnet pack CharlieBackend.AdminPanel'
				sh 'dotnet nuget push CharlieBackend.Api/bin/Debug/CharlieBackend.AdminPanel.1.0.0.nupkg --api-key 2221d13a-0e01-3d21-8d55-b0d40e35163a --source http://localhost:8081/repository/What-admin/'
			}
		}
	    	stage('Publish Api') {
			steps {
				sh 'dotnet pack CharlieBackend.Api'
				sh 'dotnet nuget push CharlieBackend.Api/bin/Debug/CharlieBackend.Api.1.0.0.nupkg --api-key 2221d13a-0e01-3d21-8d55-b0d40e35163a --source http://localhost:8081/repository/what-back/'
			}
		}
    }
}
