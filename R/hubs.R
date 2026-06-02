#'
#' @import arrow
#' 
#' @title Retrieve a remotely read parquet file of Bioconductor AnnotationHub or ExperimentHub sqlite table
#'
#' @description Traditionally using the AnnotationHub or ExperimentHub
#' Bioconductor packages required downloaded an ever-increasing SQLite file 
#' containing metadata. The SQLite tables have been converted to parquet files
#' and can be read remotely using the arrow package.
#'
#' @details Traditionally using the AnnotationHub or ExperimentHub
#' Bioconductor packages required downloaded an ever-increasing SQLite file
#' containting metadata. The SQLite tables have been converted to parquet files
#' can can be read remotely using the arrow package. The resulting object is
#' returned as an Arrow Table and is compatible with many dplyr operations.
#' 
#' @param hub A valid hub name: "annotationhub" or "experimenthub"
#'
#' @param tblname A valid parquet file name.
#'
#' @return An Arrow Table containing the requested metadata
#'
#' @author Lori Shepherd
#'
#' @aliases hub_table
#'
#' @examples
#' statuses <- hub_table("annotationhub", "statuses")
#' statuses
#'
#' @export 
hub_table <- function(hub = c("annotationhub", "experimenthub"),
                      tblname = c("resource_full", "resource_metadata",
                                  "resource_downloadlinks","input_sources",
                                  "location_prefixes","rdatapaths","resources",
                                  "statuses", "tags")
                      ){
    
    hub <- match.arg(hub)
    tblname <- match.arg(tblname)
    url <- .getHubUrl(hub, tblname)
    tbl <-
        tryCatch(
            arrow::read_parquet(url),
            error = function(e){
                warning(
                    sprintf("Could not read '%s' from location (%s)",
                            tblname, conditionMessage(e)),
                    call. = FALSE
                )
                return(NULL)
            })
    tbl
}

