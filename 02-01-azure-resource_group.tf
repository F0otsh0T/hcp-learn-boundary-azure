/* resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
} */

/* resource "random_pet" "rg_name" {
  suffix = var.resource_group_name_suffix
} */

/* resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
} */

resource "azurerm_resource_group" "rg" {
  name     = "${var.friendly_name_prefix}-${var.resource_group_name}-${var.resource_group_name_suffix}"
  location = var.location

  tags = merge(
    { "Name" = "${var.friendly_name_prefix}-${var.resource_group_name}" },
    var.common_tags
  )
}
