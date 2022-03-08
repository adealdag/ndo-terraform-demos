locals {
  # Configure this according to your scenario
  site1_name              = "MDR1"
  site2_name              = "MLG1"
  vmm_site1_name          = "vmm_vds"
  vmm_site2_name          = "vmm_vds_mlg"
  l3out_name              = "wan_l3out"
  stretched_template_name = "stretched"
  site1_template_name     = "mdr1_only"
  site2_template_name     = "mlg1_only"
  templates_deploy        = false
}

# Create Tenant
resource "mso_tenant" "demo" {
  name         = "ms_tf_demo_tn"
  display_name = "ms_tf_demo_tn"

  site_associations {
    site_id = data.mso_site.site1.id
  }

  site_associations {
    site_id = data.mso_site.site2.id
  }

  user_associations {
    user_id = data.mso_user.current_user.id
  }
}

# Schema and Templates
resource "mso_schema" "ms_prod" {
  name          = "ms_tf_demo_schema"
  template_name = local.stretched_template_name
  tenant_id     = mso_tenant.demo.id
}

resource "mso_schema_template" "ms_prod_site1_only" {
  schema_id    = mso_schema.ms_prod.id
  name         = local.site1_template_name
  display_name = local.site1_template_name
  tenant_id    = mso_tenant.demo.id
}

resource "mso_schema_template" "ms_prod_site2_only" {
  schema_id    = mso_schema.ms_prod.id
  name         = local.site2_template_name
  display_name = local.site2_template_name
  tenant_id    = mso_tenant.demo.id
}

resource "mso_schema_site" "schema_site_1_tpl1" {
  schema_id     = mso_schema.ms_prod.id
  site_id       = data.mso_site.site1.id
  template_name = mso_schema.ms_prod.template_name
}

resource "mso_schema_site" "schema_site_1_tpl2" {
  schema_id     = mso_schema.ms_prod.id
  site_id       = data.mso_site.site1.id
  template_name = mso_schema_template.ms_prod_site1_only.id
}

resource "mso_schema_site" "schema_site_2_tpl1" {
  schema_id     = mso_schema.ms_prod.id
  site_id       = data.mso_site.site2.id
  template_name = mso_schema.ms_prod.template_name
}

resource "mso_schema_site" "schema_site_2_tpl2" {
  schema_id     = mso_schema.ms_prod.id
  site_id       = data.mso_site.site2.id
  template_name = mso_schema_template.ms_prod_site2_only.id
}

# Configure template objects
module "schema_config" {
  source = "./modules/ndo_config"

  depends_on = [
    mso_schema_site.schema_site_1_tpl1,
    mso_schema_site.schema_site_1_tpl2,
    mso_schema_site.schema_site_2_tpl1,
    mso_schema_site.schema_site_2_tpl2
  ]

  schema_id            = mso_schema.ms_prod.id
  template_stretched   = mso_schema.ms_prod.template_name
  template_local_site1 = mso_schema_template.ms_prod_site1_only.id
  template_local_site2 = mso_schema_template.ms_prod_site2_only.id
  site1_id             = data.mso_site.site1.id
  site2_id             = data.mso_site.site2.id
  vmm_site1            = local.vmm_site1_name
  vmm_site2            = local.vmm_site2_name
  l3out_name           = local.l3out_name
}

# Deploy templates
resource "mso_schema_template_deploy" "template_stretched_s1_deployer" {
  depends_on = [
    module.schema_config
  ]

  schema_id     = mso_schema.ms_prod.id
  template_name = mso_schema.ms_prod.template_name
  site_id       = data.mso_site.site1.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "template_stretched_s2_deployer" {
  depends_on = [
    module.schema_config
  ]

  schema_id     = mso_schema.ms_prod.id
  template_name = mso_schema.ms_prod.template_name
  site_id       = data.mso_site.site2.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "template_local_s1_deployer" {
  depends_on = [
    module.schema_config
  ]

  schema_id     = mso_schema.ms_prod.id
  template_name = mso_schema_template.ms_prod_site1_only.id
  site_id       = data.mso_site.site1.id
  undeploy      = !local.templates_deploy
}

resource "mso_schema_template_deploy" "template_local_s2_deployer" {
  depends_on = [
    module.schema_config
  ]

  schema_id     = mso_schema.ms_prod.id
  template_name = mso_schema_template.ms_prod_site2_only.id
  site_id       = data.mso_site.site2.id
  undeploy      = !local.templates_deploy
}




