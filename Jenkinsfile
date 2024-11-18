pipeline {
    agent { dockerfile {
        filename 'Dockerfile'
        dir '.devcontainer'
    }}

    environment {
        AWS_ACCESS_KEY_ID       = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY   = credentials('aws-secret-access-key')
        AWS_SESSION_TOKEN       = credentials('aws-session-token')
        AWS_REGION              = 'ap-southeast-1'
    }

    parameters {
        choice(name: 'STATE', choices: ['apply', 'destroy'], description: 'What do you want to do?') // Fixed missing quote
    }

    stages {
        stage('Checkout Module') {
            steps {
                // Checkout the Terragrunt module repository
                withCredentials([gitUsernamePassword(credentialsId: 'git-credentials', gitToolName: 'git-tool')]) {
                   sh 'git clone https://gitlab.com/dmagsipoc1/aws-modules.git'
                }
            }
        }

        stage('Validate') {
            when {
                expression {
                    env.BRANCH_NAME in ['dev', 'uat', 'prod']
                }
            }
            steps {
                sh "terragrunt run-all validate --terragrunt-working-dir $env.BRANCH_NAME"
            }
        }

        stage('Approval') {
            steps {
                script {
                    def userInput = input(
                        message: 'Approve deployment?',
                        parameters: [
                            booleanParam(name: 'Proceed', defaultValue: false)
                        ]
                    )
                    echo "Approval received: ${userInput}"
                    echo "Candidate deployment branch: ${env.BRANCH_NAME}"

                    if (!userInput) {
                        error('Cancelling deployment.')
                    }
                }
            }
        }

        stage('Deploy Infrastructure') {
            when { 
                expression { env.BRANCH_NAME in ['dev', 'uat', 'prod'] }
                expression { params.STATE == 'apply' }
            }
            steps {
                sh "terragrunt run-all apply --terragrunt-working-dir $env.BRANCH_NAME --terragrunt-non-interactive"
            }
        }

        stage('Destroy Infrastructure') {
            when { 
                expression { params.STATE == 'destroy' } // Fixed to check for 'destroy'
                expression { env.BRANCH_NAME in ['dev', 'uat', 'prod'] }
            }
            steps {
                sh "terragrunt run-all destroy --terragrunt-working-dir $env.BRANCH_NAME --terragrunt-non-interactive"
            }
        }  
    }

    post { 
        always { 
            // Clean after build
            cleanWs()
        }
    }
}
