# install and load the package

remotes::install_github ("ropenscilabs/deposits")

library (deposits)

# make sure env vars are set
# usethis::edit_r_environ()

## maybe include a reference to JSONlite and/or an example of mapping the
## json schema to the list items

metadata <- list (
  creator = list (list (name = "C.J. Schwantes",
                        orcid = "0000-0002-9882-941X")),
  title = "Building Blocks of Reproducibility Repository",
  description = "A github repository for reproducibility best practices"
)

cli <- depositsClient$new (service = "zenodo", sandbox = TRUE, metadata = metadata)
cli$deposit_fill_metadata (metadata)

cli$metadata

## add items to deposit

## deposits is expecting CSV files -- additional arguments to supply appropriate 
# file types? A check?
cli$deposit_add_resource("./deposits_overview.md")
cli$deposit_add_resource("./deposits_tutorials.R")
cli$deposit_add_resource("./mtt.csv")

### Is there a method for adding all local resource to 
## remote? deposit_sync()?
cli$deposit_new()

cli$deposit_upload_file(path = "deposits_overview.md")
cli$deposit_upload_file(path = "deposits_tutorials.R")



