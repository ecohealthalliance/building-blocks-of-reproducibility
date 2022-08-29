#' Use js folder to create js scripts
#' 
#' Like use_r but for javascript
#'
#' @param name String. Name of file
#' @param open Logical. if True, file will open after creation
#'
#' @return
#' @export
#'
#' @examples
use_js <- function(name, open =  rlang::is_interactive() ){
  name <- sprintf("%s.js",name)
  usethis::use_directory("js")
  usethis::edit_file(usethis::proj_path("js",name), open = open)
  status <- file.exists(usethis::proj_path("js",name))
  invisible(TRUE)
}
