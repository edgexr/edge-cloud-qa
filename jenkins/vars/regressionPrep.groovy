def regressionPrep1() {
    parallel {
        stage('Check Load/Create Cycle') {
            steps {
                script {
//                    dateValue = determineDateValue()
//                    cycle = dateValue + '_' + params.Version
//                    currentBuild.displayName = cycle
                    slackMessage.good('Starting regression for ' + cycle)
                    checkLoadExists(dateValue)
                    createCycle(cycle)
                    addTestsToFolder(params.Version, params.Project, cycle)
                }
            }
        }
        stage('Cleanup Provisioning') {
            steps{
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'cleanup provisioning failed') {
                    build job: 'cleanupAutomationProvisioning'
                    script {
                        defragEtcd()
                    }
                }
            }
        }
    }
    post {
        failure {
            script {
                slackMessage.fail("Load check failed or create cycle failed for " + dateValue + '. Aborting')
            }
        }
    }
}

def regressionPrep2() {
    parallel {
        stage('Deploy Chef') {
            when { expression { params.runDeploy == true } }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'deploy chef failed') {
                    script { deployChef(dateValue) }
                }
            }
        }

        stage('Pull Image') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'pull image failed') {
                    script { pullImage(dateValue) }
                }
            }
        }

        stage('Delete Openstack') {
            when { expression { params.runDeploy == true } }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'delete openstack failed') {
                    script { deleteCrm.openstack(cycle) }
                }
            }
        }
        stage('Delete Anthos') {
            when { expression { params.runDeploy == true } }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'delete anthos failed') {
                    script { deleteCrm.anthos(cycle) }
                }
            }
        }
        stage('Delete Fake') {
            when { expression { params.runDeploy == true } }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE', message: 'delete fake failed') {
                    script { deleteCrm.fake(cycle) }
                }
            }
        }
    }
    post {
        failure {
            script {
                currentBuild.result = 'SUCCESS'
                 echo "SSSUUUUCCCCEEEESSS"
                 regression_prep_status = false
            }
        }
        success {
            script { slackMessage.good('Regression Prep successfull') }
        }
    }
}

def regressionPrepCheck()
    steps {
        script {
            if(regression_prep_status == false) {
                slackMessage.fail('Regression Prep Failed. Waiting for input')
                input message: 'Regression Prep failed. Continue?'
                slackMessage.good('Regression proceeding')
                currentBuild.result = 'SUCCESS'
                echo "SSSUUUUCCCCEEEESSS22222"
            }
        }
    }
}