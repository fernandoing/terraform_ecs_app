resource "aws_iam_user" "pipeline" {
  name = var.iam_user_name
}

resource "aws_iam_access_key" "pipeline" {
  user = aws_iam_user.pipeline.name
}

resource "aws_iam_user_policy" "pipeline" {
  name = "${var.iam_user_name}_policy"
  user = aws_iam_user.pipeline.id

#TODO: Use less priviledge set of permissions.
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ecr:*",
          "ecs:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF

  # policy = <<-EOF
  # {
  #   "Version":"2012-10-17",
  #   "Statement":[
  #       {
  #         "Sid":"RegisterTaskDefinition",
  #         "Effect":"Allow",
  #         "Action":[
  #             "ecs:RegisterTaskDefinition"
  #         ],
  #         "Resource":"*"
  #       },
  #       {
  #         "Sid":"PassRolesInTaskDefinition",
  #         "Effect":"Allow",
  #         "Action":[
  #             "iam:PassRole"
  #         ],
  #         "Resource":[
  #             "arn:aws:iam::<aws_account_id>:role/<task_definition_task_role_name>",
  #             "arn:aws:iam::<aws_account_id>:role/<task_definition_task_execution_role_name>"
  #         ]
  #       },
  #       {
  #         "Sid":"DeployService",
  #         "Effect":"Allow",
  #         "Action":[
  #             "ecs:UpdateService",
  #             "ecs:DescribeServices"
  #         ],
  #         "Resource":[
  #             "arn:aws:ecs:<region>:<aws_account_id>:service/<cluster_name>/<service_name>"
  #         ]
  #       }
  #   ]
  # }
  # EOF
}
