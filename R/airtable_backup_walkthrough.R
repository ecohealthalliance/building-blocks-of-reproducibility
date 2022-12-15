
## renv::install("ecohealthalliance/airtabler")

library(airtabler)
library(dotenv) ## allows you to use a .env file to store env variables

dotenv::load_dot_env()

# setup base parameters
base <- "appyyDpbscWX1hmEz"
metadata_table <- "Meta Data"
description_table <- "Description"


# get metadata
metadata <- airtabler::air_get_metadata_from_table(base = base, table_name = metadata_table)

description <- airtabler::air_get_base_description_from_table(base = base, table_name = description_table)

# pull base into R
base_dump <- airtabler::air_dump(base = base,metadata = metadata,description = description, add_missing_fields = TRUE)

# convert to csv
airtabler::air_dump_to_csv(base_dump,output_dir = "outputs",overwrite = FALSE)

# view csv

read.csv("outputs/7ad5b06dbf0fc714d4b51f3ba7714fef/bats.csv") |>
  View()

## create a zipped version of the folder
# hash the output to create a version
folder_id <- output_id <- rlang::hash(base_dump)

folder_path <- here::here(sprintf("outputs/%s",folder_id))

zip_name <- sprintf("outputs/%s_%s.zip",folder_id,Sys.Date())

zip_path <- here::here(zip_name)

zip(zipfile = zip_path,files = list.files(folder_path,full.names = T))

### What if your base has no meta data? ----

# setup base parameters
base <- "app56tUAR8OvZVbfp"


# get metadata
# generate metadata

metadata <- airtabler::air_generate_metadata(base,
                                             table_names = c("People","Bats"),
                                             limit = 1)

# generate description
description <- airtabler::air_generate_base_description(title = "No metadata base",
                                                        primary_contact = "Collin",email = "collin@example.com",
                                                        base_description = "this base has not  metadata :(",
                                                        github_repo= "www.github.com/some-repo",
                                                        irb = "www.example.com/irb"
                                                        )


# pull base into R
base_dump <- airtabler::air_dump(base = base,metadata = metadata,description = description, add_missing_fields = TRUE)

# convert to csv
airtabler::air_dump_to_csv(base_dump,output_dir = "outputs",overwrite = FALSE)


## create a zipped version of the folder
# hash the output to create a version
folder_id <- output_id <- rlang::hash(base_dump)

folder_path <- here::here(sprintf("outputs/%s",folder_id))

zip_name <- sprintf("outputs/%s_%s.zip",folder_id,Sys.Date())

zip_path <- here::here(zip_name)

zip(zipfile = zip_path,files = list.files(folder_path,full.names = T))


### Add files to dropbox ----

library(rdrop2)

# https://www.dropbox.com/home/airtable%20backups%20demo

# authorize dropbox 
rdrop2::drop_auth(new_user = TRUE)

# upload files
rdrop2::drop_upload(file = zip_path,path = "airtable backups demo")


## Add files to googledrive ----

library(googledrive)

# programtic auth - see chapter in eha handbook
#googledrive::drive_auth(path = "auth/your_auth_key.json")

# interactive auth
googledrive::drive_auth()

# get id of google drive folder from url
google_drive_id <- googledrive::as_id("https://drive.google.com/drive/folders/1v-YOWALo5wjdtGlNRbib6QA4vlmeuQxX")

# upload to google drive
googledrive::drive_upload(media = zip_path,path = google_drive_id,name = zip_name, type = googledrive::drive_mime_type("application/zip"))

