% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sensor_tracking.R
\name{track_sensor}
\alias{track_sensor}
\title{Reconstruct the trajectory of the LiDAR sensor using multiple returns}
\usage{
track_sensor(
  las,
  algorithm,
  extra_check = TRUE,
  thin_pulse_with_time = 0.001,
  multi_pulse = FALSE
)
}
\arguments{
\item{las}{An object of class \link[lidR:LAS-class]{LAS} or \link[lidR:LAScatalog-class]{LAScatalog}.}

\item{algorithm}{function. An algorithm to compute sensor tracking. \code{lidR} implements
\link{Roussel2020} and  \link{Gatziolis2019} (see respective documentation and examples).}

\item{extra_check}{boolean. Datasets are rarely perfectly populated, leading to unexpected errors.
Time-consuming checks of data integrity are performed. These checks can be skipped as they account
for an significant proportion of the computation time. See also section 'Tests of data integrity'.}

\item{thin_pulse_with_time}{numeric. In practice, it is not useful to compute the position using all
multiple returns. It is more computationally demanding but not necessarily more accurate. This keeps
only one pulse every x seconds. Set to 0 to use all multiple returns. Use 0 if the file has already
been read with \code{filter = "-thin_pulses_with_time 0.001"}.}

\item{multi_pulse}{logical. TRUE only for systems with multiple pulses. Pulse ID must be recorded
in the UserData attribute.}
}
\value{
A SpatialPointsDataFrame with the Z elevation stored in the table of attributes. Information
about the time interval and the score of the positioning (according to the method used) are also
in the table of attributes.
}
\description{
Use multiple returns to estimate the positioning of the sensor by computing the intersection in
space of the line passing through the first and last returns. To work, this function requires a
dataset where the 'gpstime', 'ReturnNumber', 'NumberOfReturns' and 'PointSourceID' attributes are
properly populated, otherwise the output may be incorrect or weird. For LAScatalog processing
it is recommended to use large chunks and large buffers (e.g. a swath width). The point cloud must
not be normalized.
}
\section{Test of data integrity}{

In theory, sensor tracking is a simple problem to solve as long as each pulse is properly
identified from a well-populated dataset. In practice, many problems may arise from datasets that are populated
incorrectly. Here is a list of problems that may happen. Those with a * denote problems already encountered and
internally checked to remove weird points:
\itemize{
\item 'gpstime' does not record the time at which pulses were emitted and thus pulses are not identifiable
\item *A pulse (two or more points that share the same gpstime) is made of points from different
flightlines (different PointSourceID). This is impossible and denotes an improperly populated PointSourceID
attribute.
\item 'ReturnNumber' and 'NumberOfReturns' are wrongly populated with either some ReturnNumber > NumberOfReturn
 or several first returns by pulses
}
For a given time interval, when weird points are not filtered, the position is not computed for this
interval.
}

\section{Working with a \code{LAScatalog}}{

This section appears in each function that supports a LAScatalog as input.\cr

In \code{lidR} when the input of a function is a \link[lidR:LAScatalog-class]{LAScatalog} the
function uses the LAScatalog processing engine. The user can modify the engine options using
the \link[lidR:catalog_options_tools]{available options}. A careful reading of the
\link[lidR:LAScatalog-class]{engine documentation} is recommended before processing \code{LAScatalogs}. Each
\code{lidR} function should come with a section that documents the supported engine options.\cr

The \code{LAScatalog} engine supports \code{.lax} files that \emph{significantly} improve the computation
speed of spatial queries using a spatial index. Users should really take advantage a \code{.lax} files,
but this is not mandatory.\cr
}

\section{Supported processing options}{

Supported processing options for a \code{LAScatalog} (in bold). For more details see the
\link[lidR:LAScatalog-class]{LAScatalog engine documentation}:
\itemize{
\item \strong{chunk size}: How much data is loaded at once.
\item \strong{chunk buffer*}: Mandatory to get a continuous output without edge effects. The buffer is
always removed once processed and will never be returned either in R or in files.
\item \strong{chunk alignment}: Align the processed chunks.
\item \strong{progress}: Displays a progression estimation.
\item output_files: Saving intermediate results is disabled in 'sensor_tracking' because the output
must be post-processed as a whole.
\item laz_compression: write \code{las} or \code{laz} files
\item select: is not supported. It is set by default to "xyzrntp"
\item \strong{filter}: Read only points of interest. By default it uses "-drop_single"
and "-thin_pulses_with_time" to reduce the number of points loaded.
}
}

\examples{
# A valid file properly populated
LASfile <- system.file("extdata", "Topography.laz", package="lidR")
las = readLAS(LASfile)
plot(las)

# pmin = 15 because it is an extremely small file
# strongly decimated to reduce its size. There are
# actually few multiple returns
flightlines <- track_sensor(las, Roussel2020(pmin = 15))

plot(las@header)
plot(flightlines, add = TRUE)

x <- plot(las)
add_flightlines3d(x, flightlines, radius = 10)

# Load only the data actually useful
las <- readLAS(LASfile,
               select = "xyzrntp",
               filter = "-drop_single -thin_pulses_with_time 0.001")
flightlines <- track_sensor(las,  Roussel2020(pmin = 15))

x <- plot(las)
add_flightlines3d(x, flightlines, radius = 10)

\dontrun{
# With a LAScatalog "-drop_single" and "-thin_pulses_with_time"
# are used by default
ctg = readLAScatalog("folder/")
flightlines <- track_sensor(ctg,  Roussel2020(pmin = 15))
plot(flightlines)
}
}
\author{
Jean-Francois Bourdon & Jean-Romain Roussel
}
\concept{range}
