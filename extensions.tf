resource "azurerm_virtual_machine_extension" "this" {
  name                 = "app-proxy-onboarding"
  virtual_machine_id   = azurerm_windows_virtual_machine.this.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  protected_settings   = <<PROTECTED_SETTINGS
    {
      "fileUris": ["${var.script_url}"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File bootstrap-app-proxy.ps1 -TenantId ${data.azurerm_client_config.this.tenant_id} -Token ${data.external.this.result.accessToken}"
    }
    PROTECTED_SETTINGS

  tags = local.tags
}

variable "script_url" {
  default = "https://raw.githubusercontent.com/timja/azuread-application-proxy-demo/HEAD/Bootstrap-Application-Proxy.ps1"
}

data "azurerm_client_config" "this" {}


data "external" "this" {
  program = ["bash", "${path.module}/get-access-token.sh"]
}
