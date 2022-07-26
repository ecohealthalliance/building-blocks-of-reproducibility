## Review of the `dm` package from R

DM allows you to bring a relational data model to R. 
It connects your collection of dataframes into a coherent representation of data. 
`dm` objects can be manipulated by `dplyr`/`dbplry` and `dm` also provides a set of tools to consume, create, and deploy
relational data models. Like a relational database, there are methods for key creation, key selection, and field constraint checking.
Data models built with `dm` can be ported to an RDBMS (*sql, posgres, etc). 
This means you can create a data model based on in memory data using familiar tools then
you can put that data into an database so it can scale to billions of rows. 

- Visualize data models to help understand relationships
- Joins based on known shared keys and a `flatten` operation that automatically follows keys to join tables and performs column name disambiguation
- Constraint checking for fields
- There is a single point of truth for data (they are normalized) so that updating a value in one place propagates its across linked tables

[Getting started](https://cynkra.github.io/dm/articles/dm.html)

[Why use a relational data model](https://cynkra.github.io/dm/articles/howto-dm-theory.html)

[Using dm with dataframes](https://cynkra.github.io/dm/articles/howto-dm-df.html)

[Using dm with databases](https://cynkra.github.io/dm/articles/howto-dm-db.html)


## Potential use cases

1. Keep track of data models in R
2. Create schema for airtable/odk from metadata
3. Port from Airtable to an RDBMS. 
4. Create data models in R?
5. Integrate with doltr
