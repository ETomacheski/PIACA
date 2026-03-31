ami_id        = "ami-0c02fb55956c7d316"
instance_type = "t3.micro"
app_repo_url  = "https://github.com/estevamcabral/PIACA.git"
app_dir       = "/home/ec2-user/app"

app_branches = {
  dev  = "develop"
  prod = "main"
}
