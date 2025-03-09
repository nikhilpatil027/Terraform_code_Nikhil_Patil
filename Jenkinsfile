pipeline {
    agent any

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')

    }


     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = "ap-south-1"
    }


    stages {
        stage('checkout') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                 script{
                        dir("Terraform_CICD")
                        {
                            // Check if the "terra-cloud" directory exists
                            sh '''
                                if [ -d "Terraform_code_Nikhil_Patil" ]; then
                                    echo "Directory exists. Deleting it..."
                                    rm -rf Terraform_code_Nikhil_Patil
                                fi
                                echo "Cloning the repository..."
                            sh("""
                                git clone "https://github.com/nikhilpatil027/Terraform_code_Nikhil_Patil.git"
                             """)
                        }
                    }
                }
            }

        stage('Plan') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            
            steps {
                sh 'terraform init -input=true'
                sh 'terraform workspace select ${environment} || terraform workspace new ${environment}'

                sh "terraform plan -input=true -out tfplan "
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
               not {
                    equals expected: true, actual: params.destroy
                }
           }
           steps {
               script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            
            steps {
                sh "terraform apply -input=true tfplan"
            }
        }

        stage('Configure Tomcat with Ansible')
        {
           steps {
          sh 'ansible-playbook -i inventory.ini playbook.yml'
        }
     }   
        
        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }
        
        steps {
           sh "terraform destroy --auto-approve"
        }
    }

  }
}
