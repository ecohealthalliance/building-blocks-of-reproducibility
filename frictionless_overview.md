frictionless_overview
================
Collin Schwantes
2022-12-19

\#Overview of frictionless data standard

Summary: The frictionless data standard is a general purpose structure
for data that is designed to allow you to share data in a consistent
format. Its designed to be simple and flexible while still meeting FAIR
data standards. EHA has decided to use this as our default data standard
for tabular data when a domain specific standard is not available.

### Key terms:

[Tabular
Data](https://specs.frictionlessdata.io/tabular-data-resource/) - Data
represented as a table [FAIR
Data](https://www.go-fair.org/fair-principles/) - Findable, accessible,
interoperable and reusable data. [Data
Package](https://specs.frictionlessdata.io/#what%E2%80%99s-a-data-package) -
a standard way of storing metadata and data that is human editable and
machine readable [Table
Schema](https://specs.frictionlessdata.io/table-schema/#language) -
describes how your tabular data are structured.
[Types](https://specs.frictionlessdata.io/table-schema/#types-and-formats) -
describes what kind of field is in the table using a controlled
vocabular. Default is type string. See also [Rich
Type](https://specs.frictionlessdata.io/table-schema/#rich-types)

## Walk through with Airtable backup data

``` r
library(frictionless)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
## read in csv data
people_table <- readr::read_csv("outputs/7ad5b06dbf0fc714d4b51f3ba7714fef/people.csv")
```

    ## Rows: 3 Columns: 6

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (5): id, preferred_bat_genus, name, email, notes
    ## dttm (1): created_time
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
## create package and add resource
airtable_backup_package <- frictionless::create_package() %>%  
  add_resource(resource_name = "people_table",data = people_table )

frictionless::resources(airtable_backup_package)
```

    ## [1] "people_table"

Frictionless will add a `Table Schema` automatically. This schema is a
list object that can be edited.

``` r
airtable_backup_schema <- airtable_backup_package %>% 
  frictionless::get_schema(resource_name = "people_table")

str(airtable_backup_schema)
```

    ## List of 1
    ##  $ fields:List of 6
    ##   ..$ :List of 2
    ##   .. ..$ name: chr "id"
    ##   .. ..$ type: chr "string"
    ##   ..$ :List of 2
    ##   .. ..$ name: chr "preferred_bat_genus"
    ##   .. ..$ type: chr "string"
    ##   ..$ :List of 2
    ##   .. ..$ name: chr "name"
    ##   .. ..$ type: chr "string"
    ##   ..$ :List of 2
    ##   .. ..$ name: chr "email"
    ##   .. ..$ type: chr "string"
    ##   ..$ :List of 2
    ##   .. ..$ name: chr "notes"
    ##   .. ..$ type: chr "string"
    ##   ..$ :List of 2
    ##   .. ..$ name: chr "created_time"
    ##   .. ..$ type: chr "datetime"

``` r
# see the field type for the id field
airtable_backup_schema$fields[[1]]$type
```

    ## [1] "string"

``` r
# set the field type as a universally unique id
airtable_backup_schema$fields[[1]]$type  <- "uuid"
```

Alternatively, you can create a schema on your own.

# TODO how do airtable field types map to frictionless field types

``` r
# create a new schema
people_table_schema <- frictionless::create_schema(people_table)

# read in metadata from airtable

metadata <- readr::read_csv(file = "outputs/7ad5b06dbf0fc714d4b51f3ba7714fef/metadata.csv")
```

    ## Rows: 20 Columns: 10
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (9): id, field_name, table_id, field_desc, table_name, field_type, fiel...
    ## dttm (1): created_time
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
people_metadata <- metadata %>% 
  filter(table_name == "People") 
# add descriptions to schema items

people_table_schema$fields <- purrr::map(people_table_schema$fields,function(x){
  
  field_name_i <- x$name 
  field_desc  <- people_metadata %>% 
    mutate(field_name = snakecase::to_snake_case(field_name)) %>%
    filter(field_name == {{field_name_i}}) %>% 
    pull(field_desc)
  
  x$desciption <- field_desc
  
  return(x)
})

str(people_table_schema)
```

    ## List of 1
    ##  $ fields:List of 6
    ##   ..$ :List of 3
    ##   .. ..$ name      : chr "id"
    ##   .. ..$ type      : chr "string"
    ##   .. ..$ desciption: chr(0) 
    ##   ..$ :List of 3
    ##   .. ..$ name      : chr "preferred_bat_genus"
    ##   .. ..$ type      : chr "string"
    ##   .. ..$ desciption: chr "Bats that people like"
    ##   ..$ :List of 3
    ##   .. ..$ name      : chr "name"
    ##   .. ..$ type      : chr "string"
    ##   .. ..$ desciption: chr "person's name"
    ##   ..$ :List of 3
    ##   .. ..$ name      : chr "email"
    ##   .. ..$ type      : chr "string"
    ##   .. ..$ desciption: chr "email for a person"
    ##   ..$ :List of 3
    ##   .. ..$ name      : chr "notes"
    ##   .. ..$ type      : chr "string"
    ##   .. ..$ desciption: chr "Person's role"
    ##   ..$ :List of 3
    ##   .. ..$ name      : chr "created_time"
    ##   .. ..$ type      : chr "datetime"
    ##   .. ..$ desciption: chr(0)

``` r
## add new schema to package

airtable_backup_package  <- airtable_backup_package %>% 
  # drop old resource
  frictionless::remove_resource("people_table") %>% 
  frictionless::add_resource(
    resource_name = "people_table",
    data = people_table,
    schema = people_table_schema) # explicitly adding the schema
```

Once you’re satisfied with the state of your data package you can write
it.

``` r
output_dir <- sprintf("outputs/%s", rlang::hash(airtable_backup_package)) #probably give this a human readable name

dir.create(output_dir)
```

    ## Warning in dir.create(output_dir): 'outputs/d6006ad1ea537348a174da9aa4f186d2'
    ## already exists

``` r
frictionless::write_package(package = airtable_backup_package,directory = output_dir)
```

Finally, validate your data package. The [validation
tools](https://framework.frictionlessdata.io/docs/getting-started.html)
are available in python and via the command line.

``` r
"outputs/d6006ad1ea537348a174da9aa4f186d2/people_table.csv"
```

    ## [1] "outputs/d6006ad1ea537348a174da9aa4f186d2/people_table.csv"

    frictionless validate outputs/d6006ad1ea537348a174da9aa4f186d2/people_table.csv
