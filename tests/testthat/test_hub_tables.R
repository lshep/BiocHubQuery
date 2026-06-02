
test_that("remote_connections_available",{

    url_exists <- function(url) {
        con <- url(url)
        suppressWarnings({
            tryCatch({
                open(con)
                close(con)
                TRUE
            }, error = function(e) {
                try(close(con), silent = TRUE)
                FALSE
            })
        })
    }
    expect_error(url_exists("notthere"))
    expect_true(url_exists("https://bioconductor.org"))

    AH_url  <- "https://mghp.osn.xsede.org/bir190004-bucket01/AnnotationHub/AnnotationHub/parquet/resource_full.parquet"
    expect_true(url_exists(AH_url))
    EH_url  <- "https://mghp.osn.xsede.org/bir190004-bucket01/ExperimentHub/ExperimentHub/parquet/resource_full.parquet"
    expect_true(url_exists(EH_url))

})



test_that("get_url_helper",{

    tblnames = c("resource_full", "resource_metadata",
             "resource_downloadlinks","input_sources",
             "location_prefixes","rdatapaths","resources",
             "statuses", "tags")
    hubs = c("annotationhub", "experimenthub")

    for(hub in hubs){
        for(tblname in tblnames){
            url <- BiocHubQuery:::.getHubUrl(hub, tblname)
            expect_true(!is.null(url))
        }
    }
    expect_error(BiocHubQuery:::.getHubUrl("NotAHub", "statuses"))
    expect_error(BiocHubQuery:::.getHubUrl("annotationhub", "NotATable"))
    
})

test_that("hub_table",{

    expect_error(hub_table("NotAHub", "statuses"))
    expect_error(hub_table("annotationhub", "NotATable"))
    
})    
