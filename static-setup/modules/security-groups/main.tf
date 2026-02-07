resource "aws_security_group" "redshift" {
  name        = "pp-${var.environment}-redshift-sg"
  description = "Security group for Redshift Serverless"
  vpc_id      = var.vpc_id

  ingress {
    description = "Redshift access from VPC"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "pp-${var.environment}-redshift-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "glue" {
  name        = "pp-${var.environment}-glue-sg"
  description = "Security group for Glue jobs"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "pp-${var.environment}-glue-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "glue_self_referencing" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.glue.id
  security_group_id        = aws_security_group.glue.id
  description              = "Allow Glue jobs to communicate with each other"
}
