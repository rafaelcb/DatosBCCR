#R version 3.3.1 (Bug in Your Hair)
library(RCurl)
library(XML)

getDataBCCR <- function(indicator, start="11/02/1989", end = "today",
                        name= "me", sublevels = "N"){

        if(end == "today") end = strftime(Sys.time(),"%d/%m/%Y")


        final <- data.frame(Indicador = character(),
                            Fecha = as.Date(character()),
                                  Value = numeric(),
                                  stringsAsFactors=FALSE)


        for(ind in indicator){
                baseSource <- paste("http://indicadoreseconomicos.bccr.fi.cr/",
                        "indicadoreseconomicos/WebServices/",
                "wsIndicadoresEconomicos.asmx/ObtenerIndicadoresEconomicosXML",
                                    sep = "")

                htmlRequest <- getForm(baseSource, tcIndicador = ind,
                        tcFechaInicio = start, tcFechaFinal = end,
                        tcNombre = name,tnSubNiveles = sublevels)

                #Get rid of <string> tag that messes up xmlTree
                html <- htmlParse(htmlRequest, asText = TRUE)
                temp <- xpathSApply(html, "//string", xmlValue)

                xml <- xmlTreeParse(temp)
                root <- xmlRoot(xml)
                temp <- xmlSApply(root, function(x) xmlSApply(x, xmlValue))

                #Format temp
                temp <- t(temp)
                rownames(temp) <- NULL
                temp <- as.data.frame(temp, stringsAsFactors = FALSE)
                colnames(temp) <- c("Indicador", "Fecha", "Valor")
                temp$Valor = as.numeric(temp$Valor)
                temp$Fecha <- as.Date(temp$Fecha, "%Y-%m-%d")
                final <- rbind(final, temp)

        }


        return(final)

}
