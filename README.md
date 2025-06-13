# Task 1: AWS Account Configuration

## AWS Account and S3 Bucket Setup for Terraform

1.  **Create an AWS Account**

2.  **Create an Admin Group**

    - Go to IAM > User Groups
    - Create a group (e.g., `admin`)

3.  **Create a User**

    - Assign programmatic and console access

4.  **Enable MFA and Configure Billing Alerts**

    - Enable MFA for the root account and created user
    - Set up billing alerts in the Billing section (use AWS Budgets if needed)

5.  **Add the User to the Admin Group**

6.  **Attach Policies to the Admin Group**

    - Attach the following permissions:
      - `AdministratorAccess`
      - `AmazonEC2FullAccess`
      - `AmazonRoute53FullAccess`
      - `AmazonS3FullAccess`
      - `IAMFullAccess`
      - `AmazonVPCFullAccess`
      - `AmazonSQSFullAccess`
      - `AmazonEventBridgeFullAccess`
      - `IAMAccessAnalyzerFullAccess` (important for bucket policy creation)

7.  **Create Access Keys for the User**

    - Go to IAM > Users > Security credentials tab
    - Create and download access keys

8.  **Create an S3 Bucket for Terraform**
    [terraform s3 backend permissions](https://developer.hashicorp.com/terraform/language/backend/s3)

    When creating the S3 bucket for Terraform state storage, please ensure the following:

    - The bucket is created in the **correct AWS region** matching your Terraform setup.
    - **Versioning** is enabled to keep track of state file changes and support rollback.
    - **Object Lock** is enabled to protect state files from accidental deletion or modification.

9.  **Add an S3 Bucket Policy**
    [terraform s3 backend permissions](https://developer.hashicorp.com/terraform/language/backend/s3#s3-bucket-permissions)

    Replace placeholders like `<AWS-account-ID>`, `<AWS-username>`, and `<AWS-bucket-name>` with actual values.

    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "ListBucket",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::<AWS-account-ID>:user/<AWS-username>"
          },
          "Action": "s3:ListBucket",
          "Resource": "arn:aws:s3:::<AWS-bucket-name>"
        },
        {
          "Sid": "GetPutTfState",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::<AWS-account-ID>:user/<AWS-username>"
          },
          "Action": ["s3:GetObject", "s3:PutObject"],
          "Resource": "arn:aws:s3:::<AWS-bucket-name>/terraform.tfstate"
        },
        {
          "Sid": "ManageTfLockFile",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::<AWS-account-ID>:user/<AWS-username>"
          },
          "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
          "Resource": "arn:aws:s3:::<AWS-bucket-name>/terraform.tfstate.tflock"
        }
      ]
    }
    ```

## GitHub Setup

1. Create GitHub repository
2. Create Environment variables with AWS in Settings:

- **_New environment_**
  AWS_rs-school
- **_Environment secrets_**
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY

You need to specify them in
.github/workflows/terraform.yaml

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1
```

2. Clone GitHub repository

```bash
git clone <repo-url>
cd <repo-name>
```

## Terraform Setup

1. Install tfenv

```bash
brew install tfenv
```

2. Install and pin Terraform version via tfenv

```bash
tfenv install <version>
tfenv use <version>
```

You need to specify varsion in
.github/workflows/terraform.yaml

```yaml
- name: Setup Terraform
uses: hashicorp/setup-terraform@v3
with:
    terraform_version: 1.12.1
```

3. Install and Configure AWS credentials (via CLI or manually)

Example files:

- ~/.aws/config
  ```ini
  [profile rs-school]
  region = <your-region>
  output = json
  ```
- ~/.aws/credentials
  ```ini
  [rs-school]
  aws_access_key_id = <your-access-key-id>
  aws_secret_access_key = <your-secret-access-key>
  ```

5. Git repository content structure

```bash
.
├── README.md
├── main.tf
├── terraform.tf
├── terraform.tfvars
├── terraform.yaml
└── variables.tf
└── .github
    └── workflows
        └── terraform.yaml
```

6. For more information on Terraform configuration, see:
   `terraform.tf`  
   `variables.tf`  
   `terraform.tfvars`

7. To verify that your Terraform and S3 backend configurations are correct, run:
   ```bash
   terraform init
   ```
