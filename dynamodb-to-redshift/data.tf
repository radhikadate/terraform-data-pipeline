data "terraform_remote_state" "static_setup" {
  backend = "local"

  config = {
    path = "../static-setup/terraform.tfstate"
  }
}
