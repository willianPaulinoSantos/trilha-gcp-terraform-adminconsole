provider "googleworkspace" {
  credentials             = "${file("serviceaccount.yaml")}"
  customer_id             = "informaraqui"
  impersonated_user_email = "willian@willcloudskillboost.com.br"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
    "https://www.googleapis.com/auth/admin.directory.group",	
    # include scopes as needed
  ]
}

resource "google_folder" "Financeiro" {
  display_name = "Financeiro"
  parent = "organizations/812560220698"
}

resource "google_folder" "Salesforce" {
  display_name = "Salesforce"
  parent = google_folder.Financeiro.name
}

resource "google_folder" "Desenvolvimento" {
  display_name = "Desenvolvimento"
  parent = google_folder.Salesforce.name
}

resource "google_folder" "Producao" {
  display_name = "Producao"
  parent = google_folder.Salesforce.name
}

resource "google_project" "will-financeiro-salesforce-dev" {
  name = "salesforce-dev"
  project_id = "will-financeiro-salesforce-dev"
  folder_id = google_folder.Desenvolvimento.name
  auto_create_network=false
}

resource "google_project" "will-financeiro-salesforce-prd" {
  name = "salesforce-prd"
  project_id = "will-financeiro-salesforce-prd"
  folder_id = google_folder.Producao.name
  auto_create_network=false
}

resource "googleworkspace_group" "devops" {
  email       = "devops@carlosbarbero.com.br"
  name        = "Devops"
  description = "Devops Group"

  aliases = ["dev-ops@carlosbarbero.com.br"]

  timeouts {
    create = "1m"
    update = "1m"
  }
}

resource "googleworkspace_user" "joao" {
  primary_email = "joao@carlosbarbero.com.br"
  password      = "34819d7beeabb9260a5c854bc85b3e44"
  hash_function = "MD5"

  name {
    family_name = "Joao"
    given_name  = "Ninguem"
  }
}

resource "googleworkspace_group_member" "manager" {
  group_id = googleworkspace_group.devops.id
  email    = googleworkspace_user.joao.primary_email

  role = "MANAGER"
}