aws_region = "ap-northeast-2"
name       = "lambda-eda-msk"
tags = {
  env = "dev"
}
msk_config = {
  kafka_version = "2.6.2"
}
