#' Perform source specific transformations to ensure a compatible structure.
#'
#' Map the source categories to the EDGE-T categories. Apply the full structure of the decision tree.
#'
#' @author Johanna Hoppe
#' @param x the input data read via readSource, a magpie object
#' @return a quitte object

#' @import data.table
#' @importFrom rmndt magpie2dt
#' @export

toolPrepareEUROSTAT <- function(x) {
  region <- EUROSTATsector <- period <- sector <- subsectorL1 <- subsectorL2 <- subsectorL3 <-
    vehicleType <- technology <- univocalName <- variable <- unit <- period <- NULL

  mapfile <- system.file("extdata", "mappingEUROSTATtoEDGET.csv",
   package = "mrtransport", mustWork = TRUE)
  mappingEUROSTAT <- fread(mapfile, skip = 0)
  setkey(mappingEUROSTAT, EUROSTATsector)
  dt <- magpie2dt(x)
  setkey(dt, region, EUROSTATsector, period)

  dt <- merge.data.table(dt, mappingEUROSTAT, all.x = TRUE, allow.cartesian = TRUE)

  dt <- dt[, c("region", "sector", "subsectorL1", "subsectorL2", "subsectorL3", "vehicleType",
               "technology", "univocalName", "variable", "unit", "period", "value")]
  setkey(dt, region, sector, subsectorL1, subsectorL2, subsectorL3, vehicleType, technology,
         univocalName, variable, unit, period)

  if (anyNA(dt) == TRUE) {
    stop("EUROSTAT data contains NAs")
  }
  return(dt)
}
