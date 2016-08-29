getDataBCCR <- function(indicator, start="11/02/1989", end = "today", 
                        name= "me", sublevels = "N"){
        
        if(end == "today") end = strftime(Sys.time(),"%d/%m/%Y")
        
        baseSource <- paste("http://indicadoreseconomicos.bccr.fi.cr/",
                "indicadoreseconomicos/WebServices/",
                "wsIndicadoresEconomicos.asmx/ObtenerIndicadoresEconomicosXML",
                sep = "")
        
        htmlRequest <- getForm(baseSource, tcIndicador = indicator, 
                tcFechaInicio = start, tcFechaFinal = end, tcNombre = name, 
                tnSubNiveles = sublevels)
        
        #Get rid of <string> tag that messes up xmlTree
        html <- htmlParse(htmlRequest, asText = TRUE)
        temp <- xpathSApply(html, "//string", xmlValue)
        
        xml <- xmlTreeParse(temp)
        root <- xmlRoot(xml)
        data <- xmlSApply(root, function(x) xmlSApply(x, xmlValue))
        
        #Format data
        data <- t(data)
        rownames(data) <- NULL
        data <- as.data.frame(data, stringsAsFactors = FALSE)
        colnames(data) <- c("Indicador", "Fecha", "Valor")
        data$Valor = as.numeric(data$Valor)
        data$Fecha <- as.Date(data$Fecha, "%Y-%m-%d")
        
        return(data)
        
}
