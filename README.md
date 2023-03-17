# Active Directory Federation for Keycloak

It is one of the great mysteries in life that no auth platform using LDAP has defaults for AD.

This is my best attempt to make life less sucky for us all:

## Sample

```
resource "keycloak_realm" "contoso" {
  realm   = "contoso"
  enabled = true

  default_signature_algorithm              = "RS256"
  display_name                             = "contoso"
  display_name_html                        = "<div class=\"kc-logo-text\"><span>contoso</span></div>"
  ssl_required                             = "none"

  account_theme                            = "keycloak"
  admin_theme                              = "keycloak.v2"
  email_theme                              = "keycloak"
  login_theme                              = "keycloak"
}

module "contoso_federation" {
  source = "github.com/jamesandariese/terraform-keycloak-ad-federation"
  realm_id = keycloak_realm.contoso.id
  connection_url = "ldaps://corpdc.contoso.local"
  bind_dn = "CN=svcAccountLDAP,CN=ServiceAccounts,CN=App,DC=contoso,DC=local"
  bind_credential = "SuperSecr3+"
  federation_name = "contoso"
  users_dn = "DC=contoso,DC=local
}
```
