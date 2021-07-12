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
				sh 'dotnet nuget push CharlieBackend.AdminPanel/bin/Debug/CharlieBackend.AdminPanel.1.0.0.nupkg --api-key f2502bcc-a15f-3feb-b99d-b090c2212998 --source http://nexus-loadb-6puu3e2x3dzt-1303686621.us-east-2.elb.amazonaws.com/repository/what-admin/'
			}
		}
	    	stage('Publish Api') {
			steps {
				sh 'dotnet pack CharlieBackend.Api'
				sh 'dotnet nuget push CharlieBackend.Api/bin/Debug/CharlieBackend.Api.1.0.0.nupkg --api-key f2502bcc-a15f-3feb-b99d-b090c2212998 --source http://nexus-loadb-6puu3e2x3dzt-1303686621.us-east-2.elb.amazonaws.com/repository/what-back/'
			}
		}
    }
}
