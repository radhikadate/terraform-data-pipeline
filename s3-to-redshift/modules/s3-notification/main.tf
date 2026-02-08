resource "aws_s3_bucket_policy" "redshift_access" {
  bucket = var.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "RedshiftAutoloadAccess"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetBucketNotification",
          "s3:PutBucketNotification"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_id
          }
        }
      }
    ]
  })
}

resource "null_resource" "redshift_resource_policy" {
  triggers = {
    namespace_arn = var.namespace_arn
    bucket_name   = var.bucket_name
    region        = var.region
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws redshift put-resource-policy \
        --resource-arn ${var.namespace_arn} \
        --policy '{
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "Service": "redshift.amazonaws.com"
              },
              "Action": "redshift:AuthorizeInboundIntegration",
              "Resource": "${var.namespace_arn}",
              "Condition": {
                "StringEquals": {
                  "aws:SourceArn": "arn:aws:s3:::${var.bucket_name}"
                }
              }
            },
            {
              "Effect": "Allow",
              "Principal": {
                "AWS": "arn:aws:iam::${var.account_id}:root"
              },
              "Action": "redshift:CreateInboundIntegration",
              "Resource": "${var.namespace_arn}"
            }
          ]
        }' \
        --region ${var.region}
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<-EOT
      aws redshift delete-resource-policy \
        --resource-arn ${self.triggers.namespace_arn} \
        --region ${self.triggers.region} || true
    EOT
  }

  depends_on = [aws_s3_bucket_policy.redshift_access]
}

resource "null_resource" "s3_integration" {
  triggers = {
    bucket_name = var.bucket_name
    region      = var.region
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws redshift create-integration \
        --integration-name ${var.bucket_name}-integration \
        --source-arn arn:aws:s3:::${var.bucket_name} \
        --target-arn ${var.namespace_arn} \
        --region ${var.region}
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<-EOT
      INTEGRATION_ARN=$(aws redshift describe-integrations \
        --region ${self.triggers.region} \
        --query "Integrations[?IntegrationName=='${self.triggers.bucket_name}-integration'].IntegrationArn" \
        --output text)
      if [ -n "$INTEGRATION_ARN" ]; then
        aws redshift delete-integration \
          --integration-arn $INTEGRATION_ARN \
          --region ${self.triggers.region}
      fi
    EOT
  }

  depends_on = [null_resource.redshift_resource_policy]
}
