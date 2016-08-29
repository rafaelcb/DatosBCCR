#Versión 3.3.1 (Bug in Your Hair)


library(RCurl)
library(XML)
library(dplyr)

descargarDatosBCCR <- function(indicador, inicio="11/02/1989", fin = "hoy",
                        nombre= "me", subniveles = "N"){
        time <- Sys.time()
        if(fin == "hoy") fin = strftime(Sys.time(),"%d/%m/%Y")

        # Revisar validez de parámetros
        check_date <- try(as.Date(inicio, format= "%d/%m/%Y"))
        if(is.na(check_date)) stop(paste("Valor de fecha de inicio",
        " incorrecto.\n  Intentar de nuevo con una fecha válida en formato ",
        "\"dd/mm/aaaa\" (no olvidar comillas).", sep= ""))

        check_date <- try(as.Date(fin, format= "%d/%m/%Y"))
        if(is.na(check_date)) stop(paste("Valor de fecha final",
         " incorrecto.\n  Intentar de nuevo con una fecha válida en formato ",
        "\"dd/mm/aaaa\" (no olvidar comillas).", sep= ""))


        final <- data.frame(Indicador = character(),
                            Fecha = as.Date(character()),
                                  Value = numeric(),
                                  stringsAsFactors=FALSE)


        for(ind in indicador){
                baseSource <- paste("http://indicadoreseconomicos.bccr.fi.cr/",
                        "indicadoreseconomicos/WebServices/",
                "wsIndicadoresEconomicos.asmx/ObtenerIndicadoresEconomicosXML",
                                    sep = "")

                htmlRequest <- RCurl::getForm(baseSource, tcIndicador = ind,
                        tcFechaInicio = inicio, tcFechaFinal = fin,
                        tcNombre = nombre,tnSubNiveles = subniveles)

                #Deshacerse del tag <string> que no permite usar xmlTreeParse
                html <- XML::htmlParse(htmlRequest, asText = TRUE)
                temp <- XML::xpathSApply(html, "//string", XML::xmlValue)

                xml <- XML::xmlTreeParse(temp)
                root <- XML::xmlRoot(xml)
                temp <- XML::xmlSApply(root, function(x) XML::xmlSApply(x,
                        XML::xmlValue))

                #Formato de datos
                temp <- t(temp)
                rownames(temp) <- NULL
                temp <- as.data.frame(temp, stringsAsFactors = FALSE)
                colnames(temp) <- c("Indicador", "Fecha", "Valor")
                temp$Valor = as.numeric(temp$Valor)
                temp$Fecha <- as.Date(temp$Fecha, "%Y-%m-%d")
                final <- rbind(final, temp)

        }
                #Agregar descriptores de series
                final <- final %>% left_join(cods)

        elapsed <- Sys.time() - time
        print (paste("Duración de descarga:", format(elapsed, digits = 2)))
        return(final)

}
