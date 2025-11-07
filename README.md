<!-- # terraform-project

name: Terraform CI/CD for prod

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:
  
  workflow_run: 
    workflows: [ Terraform CI/CD for dev ]
    types: completed

jobs:
  terraform:  
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    name: 'Deploy prod'
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: resources

    env:
      AWS_REGION: 'us-east-1'
      TF_VERSION: '1.11.4'

    steps:
    - name: 'Checkout GitHub repository'
      uses: actions/checkout@v2

    - name: 'Configure AWS credentials'
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ env.AWS_REGION }}

    - name: 'Set up Terraform'
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: ${{ env.TF_VERSION }}

    - name: 'Terraform Format'
      run: terraform fmt
  
    - name: 'Terraform Init for dev'
      run: terraform init -input=false -backend-config=../env/prod/backend.hcl
    

    - name: 'Terraform Validate'
      run: terraform validate

    - name: 'Terraform Plan for dev'
      run: terraform plan -var-file=../env/prod/terraform.tfvars

echo "hello"

    - name: 'Terraform Apply for dev'
      run: terraform apply --auto-approve -var-file=../env/prod/terraform.tfvars

    - name: 'Terraform destroy for dev'
      run: terraform destroy --auto-approve -var-file=../env/prod/terraform.tfvars -->
