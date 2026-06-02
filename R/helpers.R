## File for internal helpers that are not exported


.getHubUrl <- function(hub=c("annotationhub", "experimenthub"),
                       tblname = c("resource_full", "resource_metadata",
                                   "resource_downloadlinks","input_sources",
                                   "location_prefixes","rdatapaths","resources",
                                   "statuses", "tags")
                       ){
    
    hub <- match.arg(hub)
    tblname <- match.arg(tblname)
    hub <- ifelse(hub == "annotationhub", "AnnotationHub", "ExperimentHub")
    
    message(sprintf("reading '%s' parquet file \n", tblname),
            sprintf("  from '%s' ...\n", hub))
        
    s3fs <- S3FileSystem$create(
                             anonymous = TRUE,
                             endpoint_override = "https://mghp.osn.xsede.org"
                         )
    ## https://bir190004-bucket01.mghp.osn.xsede.org/index.html#ExperimentHub/ExperimentHub/parquet/
    file_path <- paste0("bir190004-bucket01/",
                        hub, "/", hub, "/", "parquet/",
                        tblname, ".parquet")
    url <- s3fs$OpenInputFile(file_path)
    return(url)
}
