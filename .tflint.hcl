plugin "aws" {
    // Plugin common attributes

    deep_check = false
    access_key = "AWS_ACCESS_KEY_ID"
    secret_key = "AWS_SECRET_ACCESS_KEY"
    region     = "us-east-1"
    profile    = "AWS_PROFILE"
    shared_credentials_file = "~/.aws/credentials"
}
