# Terraform Data Pipeline Implementation Plan

**Account:** 054158074701  
**Region:** ap-south-1  
**Project:** DynamoDB/S3 → Redshift → S3 Data Pipeline

---

## 1. STATIC INFRASTRUCTURE (Foundation Layer)

### 1.1 Networking
- **VPC:** vpc-0c12017fa98cbab0d (dbhost-vpc, CIDR: 10.11.0.0/16)
- **Subnets (Private):**
  - subnet-0c293c5fb7629213a (ap-south-1a, 10.11.128.0/20)
  - subnet-07a5f68e689cfa8d0 (ap-south-1b, 10.11.144.0/20)
- **Security Groups:**
  - sg-0537128325078f598 (dbsecuritygroup)
  - sg-076cbf784b0d4caad
  - sg-0798f776cd5d12bd3

### 1.2 Storage
- **S3 Buckets:**
  - manifest-bucket-054158074701 (source data)
  - aws-glue-assets-054158074701-ap-south-1 (Glue scripts/temp)
  - aws-cloudtrail-logs-054158074701-f4621182 (CloudTrail logs)

### 1.3 Secrets Management
- **Secrets Manager:**
  - test/redshift (Redshift credentials)
  - test/dbaccess (Database access)
  - Glue-managed connection secrets (auto-created)

### 1.4 Audit/Logging
- **CloudTrail:** data-events
  - Multi-region trail
  - KMS encryption: arn:aws:kms:ap-south-1:054158074701:key/f0e1f63d-890f-4db1-be25-1b87157c2119
  - S3 bucket: aws-cloudtrail-logs-054158074701-f4621182

### 1.5 Databases
- **DynamoDB:**
  - Table: Orders
  - Billing: PAY_PER_REQUEST
  - Streams: Enabled (NEW_IMAGE)
  - Key: PartKey (HASH)

- **RDS MySQL:**
  - Endpoint: database-1.cx0o02ucshgw.ap-south-1.rds.amazonaws.com:3306
  - Database: orders

- **Redshift Serverless:**
  - Namespace: test-redshift
  - Workgroup: default-workgroup
  - Database: dev
  - Admin: admin
  - Endpoint: default-workgroup.054158074701.ap-south-1.redshift-serverless.amazonaws.com:5439
  - Base Capacity: 128 RPU

### 1.6 IAM Roles (Static)
- **GlueFullAccessRole**
  - Service: glue.amazonaws.com
  - Policies: Glue, S3, DynamoDB, Redshift, Secrets Manager access

- **AmazonRedshift-CommandsAccessRole-20260201T170319**
  - Services: redshift.amazonaws.com, redshift-serverless.amazonaws.com, events.amazonaws.com, scheduler.redshift.amazonaws.com
  - Policies: S3, Glue Data Catalog, Secrets Manager

- **RedshiftS3role / S3RoleforRedshift**
  - Service: redshift.amazonaws.com
  - Policies: S3 read/write

---

## 2. DYNAMODB TO REDSHIFT PIPELINE

### 2.1 Event Capture
- **CloudTrail:** data-events (from static infrastructure)
  - Captures DynamoDB PutItem API calls

- **EventBridge Rule:** dynamodb-insert
  - Event Pattern: AWS API Call via CloudTrail → DynamoDB PutItem
  - Target: Step Function (LogEvent)

### 2.2 Orchestration
- **Step Function:** LogEvent
  - Type: STANDARD
  - ARN: arn:aws:states:ap-south-1:054158074701:stateMachine:LogEvent
  - Triggers: Glue Workflow

- **Glue Workflow:** Glue-EventBridge-Workflow
  - Orchestrates Glue job execution

### 2.3 Processing
- **Glue Job:** GlueTestjob
  - Type: Python Shell
  - Glue Version: 3.0
  - Max Capacity: 0.0625 DPU
  - Script: s3://aws-glue-assets-054158074701-ap-south-1/scripts/GlueTestjob.py
  - Role: GlueFullAccessRole
  - Additional modules: boto3>=1.34.0

- **Glue Job (Alternative):** DynamotoRedshift
  - Type: ETL (glueetl)
  - Glue Version: 5.0
  - Workers: 10 x G.1X
  - Script: s3://aws-glue-assets-054158074701-ap-south-1/scripts/DynamotoRedshift.py
  - Role: GlueFullAccessRole

### 2.4 Connections
- **Glue Connection:** Redshift connection
  - Type: REDSHIFT
  - Host: default-workgroup.054158074701.ap-south-1.redshift-serverless.amazonaws.com
  - Port: 5439
  - Database: dev
  - Secret: glue!054158074701-Redshiftconnection-1770324474685
  - Subnet: subnet-01830492b092ae6cf
  - Security Group: sg-0537128325078f598

### 2.5 IAM Roles
- **StepFunctions-LogEvent-role-omehw6l45**
  - Service: states.amazonaws.com
  - Policies: Glue workflow execution, CloudWatch Logs

- **Amazon_EventBridge_Invoke_Step_Functions_1920182076**
  - Service: events.amazonaws.com
  - Policies: Step Functions execution

- **Amazon_EventBridge_Invoke_Glue_1630857558**
  - Service: events.amazonaws.com
  - Policies: Glue workflow/job execution
  - Condition: Source ARN = dynamodb-insert rule

---

## 3. S3 TO REDSHIFT INTEGRATION

### 3.1 Data Source
- **S3 Bucket:** manifest-bucket-054158074701

### 3.2 Integration Method
- **Redshift Auto-copy Job** (S3 intelligent copy)
  - Status: TO BE IDENTIFIED/CONFIGURED
  - Uses: AmazonRedshift-CommandsAccessRole

### 3.3 Alternative Processing
- **Glue Job:** gluejob
  - Type: Visual ETL
  - Glue Version: 5.0
  - Workers: 10 x G.1X
  - Script: s3://aws-glue-assets-054158074701-ap-south-1/scripts/gluejob.py
  - Connection: Jdbc connection mysql (may need modification)
  - Role: GlueFullAccessRole

### 3.4 Components to Create
- Redshift auto-copy job configuration
- IAM role for auto-copy (if separate from existing)
- S3 event notifications (if needed)

---

## 4. REDSHIFT TO S3 SCHEDULED DUMP

### 4.1 Components to Create
- **EventBridge Scheduler Rule**
  - Schedule: TBD (daily/hourly)
  - Target: Lambda or Glue job

- **Lambda Function (Option 1)** or **Glue Job (Option 2)**
  - Execute Redshift UNLOAD command
  - Target S3 bucket/prefix: TBD

- **Target S3 Bucket/Prefix**
  - For exported data

### 4.2 IAM Roles to Create
- **RedshiftSchedulerRole**
  - Service: scheduler.amazonaws.com
  - Policies: Invoke Lambda/Glue, Redshift Data API

- **LambdaRedshiftUnloadRole** (if using Lambda)
  - Service: lambda.amazonaws.com
  - Policies: Redshift Data API, S3 write, CloudWatch Logs

---

## CLARIFICATION QUESTIONS

### Q1: S3 to Redshift Integration
- Is the "S3 intelligent copy auto copy job" configured in Redshift console?
- Should this be a scheduled COPY command or Redshift's auto-copy feature?

### Q2: Redshift to S3 Scheduled Dump
- What schedule is required (daily, hourly, etc.)?
- Which tables/schemas need to be exported?
- Preferred method: Lambda + Redshift Data API or Glue job?

### Q3: Glue Jobs
- Which Glue jobs are production: GlueTestjob, DynamotoRedshift, or both?
- Should gluejob be included in the pipeline?

### Q4: RDS MySQL
- Is MySQL database part of the pipeline or separate?
- Should it be in static infrastructure?

### Q5: Configuration
- Hard-code region (ap-south-1) or make configurable?
- Keep existing names or establish new naming convention?

### Q6: Glue Connection Issue
- Redshift connection shows FAILED status (STS timeout)
- Need to fix VPC/subnet configuration?

---

## TERRAFORM MODULE STRUCTURE (PROPOSED)

```
terraform-data-pipeline/
├── modules/
│   ├── static-infrastructure/
│   │   ├── networking/
│   │   ├── storage/
│   │   ├── secrets/
│   │   ├── databases/
│   │   └── iam/
│   ├── dynamodb-to-redshift/
│   │   ├── eventbridge/
│   │   ├── stepfunctions/
│   │   ├── glue/
│   │   └── iam/
│   ├── s3-to-redshift/
│   │   ├── redshift-autocopy/
│   │   └── iam/
│   └── redshift-to-s3/
│       ├── scheduler/
│       ├── lambda/ (or glue/)
│       └── iam/
├── environments/
│   ├── dev/
│   └── prod/
└── plan.md
```
