provider "aws" {
  # region = "us-east-1"
  # skip_credentials_validation = true
  # skip_requesting_account_id = true
  # access_key = "mock_access_key"
  # secret_key = "mock_secret_key"
  region = "eu-central-1"
}

resource "aws_instance" "my_web_app" {
  ami = "ami-005e54dee72cc1d00"

  instance_type = "m5.2xlarge" # <<<<<<<<<< Try changing this to m5.xlarge to compare the costs

  tags = {
    Environment = "production"
    Service = "web-app"
  }

  root_block_device {
    volume_size = 10000 # <<<<<<<<<< Try adding volume_type="gp3" to compare costs
    volume_type = "gp3"
  }
}

resource "aws_lambda_function" "my_hello_world" {
  runtime = "nodejs12.x"
  handler = "exports.test"
  image_uri = "test"
  function_name = "test"
  role = "arn:aws:ec2:us-east-1:123123123123:instance/i-1231231231"

  memory_size = 512
  tags = {
    Environment = "Prod"
  }
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "infracost-poc"
  acl    = "private"
}

resource "aws_s3_bucket_object" "my_object" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "cf_temp.json"
  source = "${path.mondule/cf_temp.json}"
}

# resource "aws_servicecatalog_product" "example" {
#   name  = "infracost-poc"
#   owner = "infracost"
#   type  = "CLOUD_FORMATION_TEMPLATE"

#   provisioning_artifact_parameters {
#    # template_url = "https://s3.amazonaws.com/cf-templates-ozkq9d3hgiq2--east-1/temp1.json"
#     template_url = "https://${aws_s3_bucket.my_bucket.bucket}.s3.amazonaws.com/${aws_s3_bucket_object.my_object.key}"

#    # https://config-bucket-721627448749.s3.eu-central-1.amazonaws.com/AWSLogs/721627448749/Config/ap-southeast-1/2023/10/14/ConfigHistory/721627448749_Config_ap-southeast-1_ConfigHistory_AWS%3A%3ARoute53Resolver%3A%3AResolverRule_20231014T080131Z_20231014T080131Z_1.json.gz
#   }

#   tags = {
#     foo = "bar"
#   }
# }

resource "aws_servicecatalog_product" "example" {
  name  = "infracost-poc"
  owner = "infracost-poc"
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    template_url = "https://cf-templates-7eb6zh9bzc5d-eu-central-1.s3.eu-central-1.amazonaws.com/servicecatalog-product-42859277-2acb-44d2-847c-e6e568eb29b9-s3bucket.tar.gz"
  }

 
}