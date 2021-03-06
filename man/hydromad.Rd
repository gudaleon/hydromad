\name{hydromad}
\alias{hydromad}
\title{
  Specify rainfall - runoff (hydrology) models.
}
\description{
  The \code{hydromad} function can be used to specify models with their
  model equations, data, parameters and settings. It allows a general
  two-component structure, where the Soil Moisture Accounting
  (\code{sma}) component and the Routing (\code{routing}) component can
  be arbitrary functions. A method can be specified for fitting the
  dependent routing component.
}
\usage{
hydromad(DATA = zoo(), ...,
        sma = hydromad.getOption("sma"),
        routing = hydromad.getOption("routing"),
        rfit = NULL, warmup = hydromad.getOption("warmup"))
}
\arguments{
  \item{DATA}{
    a \code{\link{ts}}-like object with named columns:
    \describe{
      \item{\code{P}}{
	time series of areal rainfall depths, usually in mm.
      }
      \item{\code{E}}{
	(optional) time series of potential evapo-transpiration, or more
	typically, temperature as an indicator of this. Required for
	some models but not others.  
      } 
      \item{\code{Q}}{
	(optional) time series of discharge (streamflow) at the
	catchment outlet. Required for calibration but not simulation.
	It should usually be in units of mm (averaged over the catchment
	area). Use \code{\link{convertFlow}} to convert it.
      }
      \item{etc.}{
	other data columns may also be included, and will be accessible
	via the \code{observed()} method.
      }
    }
  }
  \item{\dots}{
    values or ranges for named parameters. Any parameters not given here
    will be taken from defaults given in \code{hydromad.options(sma)}
    and/or \code{hydromad.options(routing)}. In addition, other
    arbitrary arguments may be given here that will be passed on to the
    simulation function(s) and not treated as parameters. To specify a
    numeric object that is not a parameter (such as a time series
    object), wrap it in \code{\link{I}()}. 
  }
  \item{sma}{
    name of the Soil Moisture Accounting (SMA) component. May be
    \code{NULL}, in which case the input rainfall will be passed
    directly to \code{routing}. If \code{sma} is specified, a
    corresponding simulation function \var{sma}\code{.sim} must exist.
  }
  \item{routing}{
    name of the routing component (i.e. the component which takes in
    effective rainfall from \code{sma} and converts it to streamflow).
    May be \code{NULL}, in which case the model output is taken as the
    output from \code{sma} directly. 
  }
  \item{rfit}{
    optional specification for fitting the routing component. If a
    character string is given, then a corresponding function
    \var{routing}\code{.}\var{rfit}\code{.fit} must exist.
  }
  \item{warmup}{
    warmup period in number of time steps.
  }
}
\details{
  The \code{hydromad()} function allows models to be specified with
  the given component models and parameter specifications. The resulting
  object can later be modified using the
  \code{\link[=update.hydromad]{update}} method using the same syntax.
  
  Methods for working with the model objects are listed under
  \code{\link{hydromad.object}}.

  For a tutorial, type
  \code{vignette("tutorial", package = "hydromad")}.

  For an overview of the package, see the paper
  \code{vignette("hydromad_paper")}.

  For a list of the package functions with their help pages, see the
  website \url{http://hydromad.catchment.org/}.
}
\value{
  the result from \code{hydromad()} is a
  \link[=hydromad.object]{hydromad object}.
}
\references{
  F.T. Andrews, B.F.W. Croke and A.J. Jakeman (2011). An open software
  environment for hydrological model assessment and
  development. \emph{Environmental Modelling and Software} 26 (2011),
  pp. 1171-1185. \url{http://dx.doi.org/10.1016/j.envsoft.2011.04.006}
}
\author{ Felix Andrews \email{felix@nfrac.org} }
\seealso{
  \code{\link{hydromad.object}}
}
\examples{
data(Cotter)
x <- Cotter[1:1000]

## IHACRES CWI model with exponential unit hydrograph
## an unfitted model, with ranges of possible parameter values
modx <- hydromad(x, sma = "cwi", routing = "expuh",
                 tau_s = c(2,100), v_s = c(0,1))
modx
## now try to fit it
fitx <- fitByOptim(modx)
fitx
summary(fitx)
xyplot(fitx, with.P = TRUE, type = c("l", "g"))

data(Canning)
x <- window(Canning, start = "1980-01-01", end = "1982-01-01")
xyplot(x)
## IHACRES CWI model with extra parameter l
## Fixed UH (fit once) by inverse method
## an unfitted model, with ranges of possible parameter values
mod0 <- hydromad(x, sma = "cwi", l = c(0, 100), 
             routing = "armax", rfit = list("inverse", order = c(1,1)))
mod0
## now try to fit the free parameters
fit1 <- fitByOptim(mod0)
fit1
summary(fit1)
xyplot(fit1)
}
\keyword{ models }
