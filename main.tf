variable "realm_id" { type = string }
variable "connection_url" { type = string }
variable "bind_dn" { type = string }
variable "bind_credential" {
  type = string
  sensitive = true
}
variable "federation_name" { type = string }
variable "users_dn" { type = string }
variable "custom_user_search_filter" {
  type = string
  default = "(&(mail=*))"
}

resource "keycloak_ldap_user_federation" "fed" {
  name     = var.federation_name
  realm_id = var.realm_id
  enabled  = true

  batch_size_for_sync             = 0
  bind_dn                         = var.bind_dn
  bind_credential                 = var.bind_credential
  changed_sync_period             = 86400
  connection_timeout              = "5s"
  connection_url                  = var.connection_url
  full_sync_period                = 86400
  pagination                      = false
  rdn_ldap_attribute              = "cn"
  search_scope                    = "SUBTREE"
  sync_registrations              = true
  trust_email                     = true
  user_object_classes             = [
    "person",
    "organizationalPerson",
    "user",
  ]
  username_ldap_attribute         = "sAMAccountName"
  users_dn                        = var.users_dn
  uuid_ldap_attribute             = "objectGUID"
  vendor                          = "AD"
  custom_user_search_filter       = var.custom_user_search_filter
  read_timeout                    = "15s"
}

resource "keycloak_ldap_user_attribute_mapper" "last_name" {
  realm_id                = var.realm_id
  ldap_user_federation_id = keycloak_ldap_user_federation.fed.id

  name                 = "last name"
  is_mandatory_in_ldap = true
  always_read_value_from_ldap = true
  ldap_attribute       = "sn"
  read_only            = true
  user_model_attribute = "lastName"
}

resource "keycloak_ldap_user_attribute_mapper" "email" {
  realm_id                = var.realm_id
  ldap_user_federation_id = keycloak_ldap_user_federation.fed.id

  name                 = "email"
  is_mandatory_in_ldap = false
  ldap_attribute       = "mail"
  read_only            = true
  user_model_attribute = "email"
}

resource "keycloak_ldap_user_attribute_mapper" "creation_date" {
  realm_id                = var.realm_id
  ldap_user_federation_id = keycloak_ldap_user_federation.fed.id

  name                 = "creation date"
  always_read_value_from_ldap = true
  is_mandatory_in_ldap = false
  ldap_attribute       = "whenCreated"
  read_only            = true
  user_model_attribute = "createTimestamp"
}

resource "keycloak_ldap_user_attribute_mapper" "modify_date" {
  realm_id                = var.realm_id
  ldap_user_federation_id = keycloak_ldap_user_federation.fed.id

  name                 = "modify date"
  is_mandatory_in_ldap = false
  always_read_value_from_ldap = true
  ldap_attribute       = "whenChanged"
  read_only            = true
  user_model_attribute = "modifyTimestamp"
}

resource "keycloak_ldap_user_attribute_mapper" "username" {
  realm_id                = var.realm_id
  ldap_user_federation_id = keycloak_ldap_user_federation.fed.id

  name = "username"
  is_mandatory_in_ldap = true
  ldap_attribute       = "sAMAccountName"
  read_only            = true
  user_model_attribute = "username"
}

resource "keycloak_ldap_full_name_mapper" "full_name" {
  realm_id                 = var.realm_id
  ldap_user_federation_id  = keycloak_ldap_user_federation.fed.id
  name                     = "full name"
  ldap_full_name_attribute = "displayName"
  read_only                = true
}

resource "keycloak_ldap_msad_user_account_control_mapper" "msad_user_account_control_mapper" {
  realm_id                 = var.realm_id
  ldap_user_federation_id  = keycloak_ldap_user_federation.fed.id
  name                     = "MSAD account controls"
}

