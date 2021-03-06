% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Class-LASheader.R
\docType{class}
\name{LASheader-class}
\alias{LASheader-class}
\title{An S4 class to represent the header of .las or .laz files}
\description{
An S4 class to represent the header of .las or .laz files according to the
\href{http://www.asprs.org/a/society/committees/standards/LAS_1_4_r13.pdf}{LAS file format specifications}.
A \code{LASheader} object contains a \code{list} in the slot \code{@PHB} with
the data read from the Public Header Block and \code{list} in the slot \code{@VLR} with
the data read from the Variable Length Records
}
\section{Slots}{

\describe{
\item{\code{PHB}}{list. Represents the Public Header Block}

\item{\code{VLR}}{list. Represents the Variable Length Records}
}}

