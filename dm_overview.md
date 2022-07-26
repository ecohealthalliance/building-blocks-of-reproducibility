## Review of the `dm` package from R

DM allows you to bring a relational data model to R. 
It connects your collection of dataframes into a coherent representation of data. 
`dm` objects can be manipulated by `dplyr` and `dm` also provides a set of tools to consume, create, and deploy
relational data models. Like a relational database, there are methods for key creation, key selection, and field constraint checking.
Data models built with `dm` can be ported to an RDBMS (mysql, posgres, etc). 
This means you can create a data model based on in memory data using familiar tools then
you can put that data into an database so it can scale to billions of rows. 

## Potential use cases

1. Keep track of data models in R
2. Create schema for airtable/odk from metadata
3. Port from Airtable to an RDBMS. 
