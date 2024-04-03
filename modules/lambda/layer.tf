resource "aws_lambda_layer_version" "pymysql_layer" {
    s3_bucket   = var.s3_bucket
    s3_key = "layers/lambda_layers.zip"
    layer_name = "expenses_layer"
  compatible_runtimes = ["python3.12"] 
}
