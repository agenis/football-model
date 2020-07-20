library(googleComputeEngineR)
myproject = "foot"
myzone = "europe-west1-b"
account_key = "foot-json2.json"
Sys.setenv(GCE_AUTH_FILE = account_key,
           GCE_DEFAULT_PROJECT_ID = myproject,
           GCE_DEFAULT_ZONE = myzone)
gce_auth()
gce_global_project(myproject)
gce_global_zone(myzone)
gce_get_project("foot")
vm <- gce_vm_template(template = "rstudio",
             name = "my-rstudio",
             username = "tnf", password = "tnf",
             predefined_type = "f1-micro")
