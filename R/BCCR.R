### R Versión 3.3.1 (Bug in Your Hair)
### Función para descargar datos del BCCR
#########################################

DescargarDatosBCCR <- function(indicador, inicio="11/02/1989", fin = "hoy",
                         subniveles = "N", nombre= "me"){
        time <- Sys.time()

        if (fin == "hoy") fin = strftime(Sys.time(),"%d/%m/%Y")


        # Revisar validez de parámetros
        if (!InputValid(indicador, inicio, fin, subniveles)) {
                stop("Imposible realizar solicitud con parámetros ingresados.")
        }

        url <- paste("http://indicadoreseconomicos.bccr.fi.cr/",
        "indicadoreseconomicos/WebServices/wsIndicadoresEconomicos.asmx",
        sep = "")
        baseSource <- paste(url,"/ObtenerIndicadoresEconomicosXML",
                            sep = "")
        primero = TRUE
        for (ind in indicador) {
                if (!as.character(ind) %in% cods$Indicador) next
                serverResponse <- httr::status_code(httr::GET(url))
                if (serverResponse == 200) {
                        htmlRequest <- RCurl::getForm(baseSource,
                        tcIndicador = ind, tcFechaInicio = inicio,
                        tcFechaFinal = fin, tcNombre = nombre,
                        tnSubNiveles = subniveles)
                }else stop("No se ha podido conectar al servidor.")


                # Deshacerse del tag <string> que no permite usar xmlTreeParse
                # y luege obtener datos
                temp <- htmlRequest %>% XML::htmlParse(asText = TRUE) %>%
                        XML::xpathSApply("//string", XML::xmlValue) %>%
                        XML::xmlTreeParse() %>% XML::xmlRoot() %>%
                        XML::xmlSApply(function(x) XML::xmlSApply(x,
                        XML::xmlValue))

                # Corregir series para las que el sistema retorna valores vacíos
                # para determinadas fechas (v.gr. fines de semana)
                if (class(temp) == "list") {
                        temp <- sapply(temp,
                        function(x) {if (is.na(x[3])) x <- c(x, "NA"); x})
                }

                #Formato de datos
                temp <- tibble::as_tibble(t(temp))
                colnames(temp) <-  c("Indicador", "Fecha", "Valor")
                #Elimina advertencia por generación de NA's
                suppressWarnings(temp$Valor <-
                                         as.numeric(temp$Valor))
                temp$Fecha <- as.Date(temp$Fecha, "%Y-%m-%d")
                temp <- temp %>% dplyr::left_join(cods, "Indicador") %>%
                        dplyr::select(-Indicador, -Periodicidad) %>%
                        tidyr::spread(Nombre,Valor)

                if (primero) {
                        final <- temp
                        primero = FALSE
                }
                else final <- final %>% dplyr::full_join(temp, by = "Fecha")

        }

        elapsed <- Sys.time() - time
        message(paste0("Duración de descarga: ", format(elapsed, digits = 2),
                      ".\nResultado: ", NROW(final)," observaciones."))
        return(final)

}

#Función secundaria para controlar que los parámetros sean válidos
InputValid <- function(indicador, inicio, fin, subniveles){

        is.ok <- TRUE
        date_err <- paste("Valor de fecha incorrecto.\n",
                         "  Intentar de nuevo con una fecha válida en formato ",
                         "\"dd/mm/aaaa\" (no olvidar comillas).", sep =  "")

        check_date <- try(as.Date(inicio, format = "%d/%m/%Y"))
        if (class(check_date) == "try-error" | is.na(check_date)) {
                message(paste("Fecha inicio: ", date_err, sep =  ""))
                is.ok <- FALSE
        }

        check_date <- try(as.Date(fin, format = "%d/%m/%Y"))
        if (class(check_date) == "try-error" | is.na(check_date)) {
                message(paste("Fecha final: ", date_err, sep = ""))
                is.ok <- FALSE
        }

        if (subniveles != "N" & subniveles != "S") {
                message("Subniveles solo puede tener los valores \"S\" o \"N\"")
                is.ok <- FALSE
        }

        counter = 0
        for (ind in indicador) {
                if (!as.character(ind) %in% cods$Indicador) {
                        message(paste0("Indicador ", ind, " no existe. ",
                        "Revisar lista completa usando View(cods)."))
                        counter = counter + 1
                }
        }

        if (counter == NROW(indicador)) {
                message(" --Ningún indicador válido.--")
                is.ok <- FALSE
        }


        return(is.ok)

}
