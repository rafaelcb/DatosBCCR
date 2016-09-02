# DatosBCCR
Función para conectarse al API del BCCR y descargar las series directamente a R.
Requiere instalación previa de los siguientes paquetes: RCurl, httr, dplyr, tibble, magrittr y XML.
En caso de no estar instalados, los paquetes son descargados automáticamente en el momento de la instalación (descrita abajo).
Para una descripción del API, ver: http://www.bccr.fi.cr/indicadores_economicos_/ServicioWeb.html.

##Instalación

Para instalar el paquete se deben seguir dos pasos:

1. Instalar el paquete devtools (`install.packages("devtools"); library("devtools")`).
2. Utilizar el comando de instalación desde github: `install_github("rafaelcb/DatosBCCR")`

## Uso

La función de descarga es `DescargarDatosBCCR(indicador, inicio="11/02/1989", fin = "hoy", subniveles = "N", nombre= "me")`. La función retorna un [tibble](https://blog.rstudio.org/2016/03/24/tibble-1-0-0/) en formato largo.

### Parámetros
* El _indicador_ es el único parámetro obligatorio. Se trata de un número de serie que puede ser obtenido del listado disponible a través de `View(cods)`. Para varias series, se puede utilizar un vector numérico (`DescargarDatosBCCR(c(1, 317))` retorna por ejemplo el tipo de cambio de compra diario y la cuenta corriente trimestral).

* Las fechas de _inicio_ y _fin_ son aquellas que se desean intentar descargar. Deben ser ingresadas como texto y en formato "dd/mm/aaaa". Para la fecha final, el parámetro `"hoy"`puede ser usado para referenciar la fecha del sistema.

* El parámetro _subniveles_ se refiere a la posibilidad de descargar ciertas variables relacionadas a la de interés. Sólo puede tener uno de dos valores, `"S"` si se quiere descargar las dependencias o `"N"` si no. Por ejemplo, `DescargarDatosBCCR(1, subniveles = "S")` retorna 14 series con los distintos componentes de la cuenta corriente. Para determinar si existen subniveles, se debe realizar una inspección visual de las series [en el sitio del BCCR](http://www.bccr.fi.cr/indicadores_economicos_/ServicioWeb.html), ya que la indentación indica las relaciones entre variables.

* Por último, el parámetro _nombre_ se refiere a una cadena de texto que sirve como referencia para que el API tenga un control respecto a quién descarga los datos.



**Versión 0.3.0: Agosto 2016**




