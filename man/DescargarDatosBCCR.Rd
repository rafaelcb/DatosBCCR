\name{DescargarDatosBCCR}
\alias{DescargarDatosBCCR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Descargar datos del API del BCCR
%%  ~~function to do ... ~~
}
\description{Función para descargar series de datos de la economía costarricense del API del BCCR directamente a R. La función retorna un data.frame en formato largo, lo que facilita graficar los datos con ggplot.

%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
DescargarDatosBCCR(indicador, inicio = "11/02/1989", fin = "hoy", subniveles = "N", nombre = "me")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{indicador}{El indicador es el único parámetro obligatorio. Se trata de un número de serie que puede ser obtenido del listado disponible usando \code{View(cods)} o el sitio web del BCCR. Para varias series, se puede utilizar un vector numérico con múltiples códigos.
%%     ~~Describe \code{indicador} here~~
}
  \item{inicio}{
        Fecha a partir de la cual se desea descargar observaciones. Debe ser una cadena texto y en formato \code{"dd/mm/aaaa"}.
%%     ~~Describe \code{inicio} here~~
}
  \item{fin}{
%%     ~~Describe \code{fin} here~~
        Fecha hasta la cual se desea descargar observaciones. Debe ser una cadena texto y en formato \code{"dd/mm/aaaa"}.Alternativamente, la cadena de texto \code{"hoy"} es interpretada como la fecha del sistema y es usada en ausencia de un parámetro explícito.
}
  \item{subniveles}{
%%     ~~Describe \code{subniveles} here~~
Se refiere a la posibilidad de descargar ciertas variables relacionadas a la de interés. Sólo puede tener uno de dos valores, \code{"S"}" si se quiere descargar las dependencias o \code{"N"} si no. Para determinar si existen subniveles se debe realizar una inspección visual de las series en el sitio del BCCR (\url{http://www.bccr.fi.cr/indicadores_economicos_/ServicioWeb.html}), ya que la indentación indica las relaciones entre variables.
}
  \item{nombre}{
%%     ~~Describe \code{nombre} here~~
Cadena de texto que sirve como referencia para que el API tenga un control respecto a quién descarga los datos.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{\url{http://www.bccr.fi.cr/indicadores_economicos_/ServicioWeb.html}
%% ~put references to the literature/web site here ~
}
\author{Rafael Castrillo
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
# Descargar el tipo de cambio de compra diario y la cuenta corriente trimestral entre el 1 de enero de 2000 y el 31 de diciembre de 2010:
        DescargarDatosBCCR(c(1, 317), inicio = "01/01/2000", fin = "31/12/2010")

# Retorna 14 series con los distintos componentes de la cuenta corriente:
        DescargarDatosBCCR(1, subniveles = "S")
 }

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
