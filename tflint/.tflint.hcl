plugin "aws" {
    // Plugin common attributes
    enabled    = true
    version    = "0.5.0"
    source     = "github.com/terraform-linters/tflint-ruleset-aws"
    deep_check = true
    region     = "us-east-1"
    profile    = "default"
    shared_credentials_file = "~/.aws/credentials"
}
