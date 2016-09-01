InfoBD <- function(id.BD){

        datos <- list()
        base <- "http://dataservices.imf.org/REST/SDMX_JSON.svc/DataStructure/"
        url <- paste0(base, id.BD)
        json <- jsonlite::fromJSON(url)
        dim <- json$Structure$KeyFamilies$KeyFamily$Components$Dimension$"@codelist"
        datos[["dimensiones_BD"]] <- data.frame(dimension =
                paste0("dimensión_ ", 1:NROW(dim)), id = dim)
        códigos <- json$Structure$CodeLists$CodeList$Code
        lista.códigos <- json$Structure$CodeLists$CodeList$Name$"#text"
        for(i in 1:NROW(lista.códigos)){
                datos[[lista.códigos[i]]] =
                data.frame(indicador = códigos[[i]]$"@value",
                descripción = códigos[[i]]$Description$"#text")
        }

        return(datos)

}


DescargarDatosFMI <- function(id.BD, inicio, fin, ...){
        lista.pars <- list(...)
        base <- "http://dataservices.imf.org/REST/SDMX_JSON.svc/CompactData/" %>%
                paste0(id.BD,"/")
        n <- length(lista.pars)
        for(i in 1:n){

        base <- paste0(base, paste0(lista.pars[[i]], collapse ="+"), ".")
        }


        base <- paste0(base, "?startPeriod=", inicio, "&endPeriod=", fin)

        message(paste("Extrayendo datos del URL:", base))
        raw <- jsonlite::fromJSON(base)
        series <- raw$CompactData$DataSet$Series
        descriptores <- series[1:n]
        for(i in 1:length(series$Obs)){
                if(class(series$Obs) == "list"){
                        if(i == 1) {
                                datos <- series$Obs[[i]][, 1:2]
                                colnames(datos) <- c("Fecha",
                                paste0(descriptores[i, ], collapse = "."))
                        }
                        else {
                                datos <- cbind(datos, series$Obs[[i]][,2])
                                colnames(datos)[i + 1] <-
                                c(paste0(descriptores[i, ], collapse = "."))
                        }
                }
                else {
                        datos <- series$Obs[, 1:2]
                        colnames(datos) <- c("Fecha", paste0(descriptores,
                        collapse = "."))
                }

        }
        if(class(series$Obs) == "list")
                datos[, -1] <- apply(datos[,-1],2, as.numeric)
        else
                datos[, -1] <- as.numeric(datos[, -1])
        return(datos)
}

#TODO Add Metadata
