## walk through basic functionality of Zenodo ----

remotes::install_github("ropenscilabs/deposits")
## deposit to sandbox
library(deposits)

cli <- depositsClient$new ("zenodo", sandbox = TRUE)

cli$ping()

### Metadata instructions are very clear.
deposits_metadata_template(filename = "test_meta_data.json")
### Can I move files/repos to Zenodo via the api? 
cli$up

## walk through basic functionality of Dryad ----