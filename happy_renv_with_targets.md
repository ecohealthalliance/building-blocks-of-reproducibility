The `renv` and `targets` packages are partners in reproducible research workflows. 

`renv` is used to manage the R package dependecnies for your project, 
while `targets` allows you to create a workflow that can be readily passed from one machine to another. 

A typical `targets` workflow will have a file called "packages.R" that lists all the packages used in the repo. 
`renv` can scan that file (and any other files in the project) to determine what the package dependencies are for a given project. 
`renv` can then store the metadata data (version, source, etc) for those packages in the "renv.lock" file. 

When adding a new package to a project with `renv` and `targets`, the process might look something like this: 


1) Add package to "packages.R"

``` 
# in packages.R

library(tidyverse)
library(some_new_package)

```

2) install the package from appropriate source OR use `renv::hydrate` to bulk install

```
# in R console

## install the new package 

# from cran OR
renv::install("some_new_package")
# from github OR
renv::install("my_repo/some_new_package")
# from bioconductor
renv::install("bioc::some_new_package")


## auto install

renv::hydrate()

```

3) Update the lock file
```
# in R console
## check what packages have changed or need to be installed
renv::status()

## update the renv.lock file
renv::snapshot()
```

4) Push changes to the lockfile
```
# in terminal

git add renv.lock
git add packages.R
git commit -m "updated lock.file with some_new_package"
git push
```
