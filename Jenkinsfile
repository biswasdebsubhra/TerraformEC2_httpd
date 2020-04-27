/*pipeline {
agent none*/
node {
  git url: 'https://github.com/biswasdebsubhra/TerraformEC2_httpd.git'
  stage('init') {
    sh label: 'Initialize Terraform', script: "/usr/local/bin/terraform init"
  }
  stage('plan') {
    sh label: 'Plan Terraform', script: "/usr/local/bin/terraform plan -out=tfplan -input=false"
    script {
        timeout(time: 10, unit: 'MINUTES') {
          input(id: "Deploy Gate", message: "Deploy environment?", ok: 'Deploy')
        }
    }
  }
  stage('apply') {
    sh label: 'Deploy Infrastructure', script: "/usr/local/bin/terraform apply -lock=false -input=false tfplan"
  }
 }
/*}*/
post { 
  always { 
    cleanWs()
   }
  }
