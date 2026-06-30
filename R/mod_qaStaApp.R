#' qaStaApp UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_qaStaApp_ui <- function(id){
  ns <- NS(id)
  tagList(

    tags$br(),
    # input <- list(traitOutqPheno="YLD_TON-residual",traitLBOutqPheno=-4,traitUBOutqPheno=4,outlierCoefOutqPheno=2.5, outlierCoefOutqFont=12 )

    shiny::mainPanel(width = 12,
                     tabsetPanel( id=ns("tabsMain"), #width=9,
                       type = "tabs",
                       tabPanel(div(icon("book"), "Information") ,
                                br(),
                                column(width=6,   #style = "height:660px; overflow-y: scroll;overflow-x: scroll;",
                                       tags$body(
                                         h1(strong(span("Model-Based Outlier Detection Module", style="color:darkcyan"))),
                                         h2(strong("Data Status (wait to be displayed):")),
                                         uiOutput(ns("warningMessage")),

                                         tags$br(),
                                         # column(width=3, tags$br(),
                                         shinyWidgets::prettySwitch( inputId = ns('launch'), label = "Load example dataset", status = "success"),
                                         # ),
                                         tags$br(),
                                         img(src = "www/qaSta.png", height = 200, width = 470), # add an image
                                       )
                                ),
                                column(width=6,   #style = "height:660px; overflow-y: scroll;overflow-x: scroll;",
                                       h2(strong("Details")),
                                       p("The two-step approach of genetic evaluation allows to identify noisy records after the single trial analysis.
                                                             This option aims to allow users to select model-based outliers based on plot whiskers and absolute values applied on conditional residuals.
                                The way arguments are used is the following:"),
                                       p(strong("Genetic evaluation unit.-")," One or more of the following; designation, mother, father to indicate which column(s) should be considered the unit of genetic evaluation to compute BLUEs or BLUPs in the single trial analysis step."),
                                       p(strong("Traits to analyze.-")," Traits to be analyzed. If no design factors can be fitted simple means are taken."),
                                       h2(strong("References")),
                                       p("Tukey, J. W. (1977). Exploratory Data Analysis. Section 2C."),
                                       p("McGill, R., Tukey, J. W. and Larsen, W. A. (1978). Variations of box plots. The American Statistician, 32, 12–16. doi:10.2307/2683468."),
                                       p("Velleman, P. F. and Hoaglin, D. C. (1981). Applications, Basics and Computing of Exploratory Data Analysis. Duxbury Press."),
                                ),
                       ),
                       tabPanel(div(icon("arrow-right-to-bracket"), "Input steps"),
                                tabsetPanel(id=ns("tabInput"),
									tabPanel(value="tabsInputStamp",title=div(icon("dice-one"), "Pick QA-stamp(s)", icon("arrow-right") ) , #icon = icon("dice-one"),
                                                          br(),
                                                          column(width=12,style = "background-color:grey; color: #FFFFFF",
                                                                 column(width=8,
                                                                        selectInput(ns("version2qSta"),
                                                                                    label = tags$span(
                                                                                      "Pheno-modification stamp(s) to apply to the data",
                                                                                      tags$i(
                                                                                        class = "glyphicon glyphicon-info-sign",
                                                                                        style = "color:#FFFFFF",
                                                                                        title = "Analysis ID(s) from QA modifications that should be applied in the Outlier detection."
                                                                                      )
                                                                                    ),
                                                                                    choices = NULL, multiple = TRUE),
                                                                 ),

                                                          ),
                                                          column(width=12),
                                                          shinydashboard::box(width = 12, status = "success",solidHeader=TRUE,collapsible = TRUE, collapsed = TRUE, title = "Visual aid (click on the '+' symbol on the right to open)",
                                                                              column(width=12,
                                                                                     hr(style = "border-top: 3px solid #4c4c4c;"),
                                                                                     h5(strong(span("The visualizations of the input-data located below will not affect your analysis but may help you pick the right input-parameters to be specified in the grey boxes above.", style="color:green"))),
                                                                                     hr(style = "border-top: 3px solid #4c4c4c;"),
                                                                              ),
                                                                              column( width=12, shiny::plotOutput(ns("plotTimeStamps")) ),
                                                                              DT::DTOutput(ns("statusSta")), # modeling table
                                                                              DT::DTOutput(ns("phenoSta")),
                                                          ),
                                                 ),##Finish pick stamp
                                  tabPanel(div(icon("dice-two"), "Pick parameters", icon("arrow-right") ), value = "PickParms",# icon = icon("dice-one"),
                                           br(),
                                           column(width=12, style = "background-color:grey; color: #FFFFFF",
                                                  column(width=2, selectInput(ns("traitOutqPhenoMultiple"), "Trait(s) to QA",
                                                                tags$i(
                                                                  class = "glyphicon glyphicon-info-sign",
                                                                  style = "color:#FFFFFF",
                                                                  title = "Trait(s) that should be used as fixed effect covariate. Only to be used if a field correction besides the spatial model is needed."
                                                                ), choices = NULL, multiple = TRUE)
                                                  ),
                                                  column(width=2,selectInput(ns("genoUnitOutqP"),label = tags$span("Genetic evaluation unit(s)",
                                                                       tags$i(
                                                                         class = "glyphicon glyphicon-info-sign",
                                                                         style = "color:#FFFFFF",
                                                                         title = "Depending on the crop this selection can be males and females for progeny-testing models (e.g., GCA), or designation for per-se performance models. "
                                                                       )
                                                                     ),
                                                                     choices = NULL, multiple = TRUE)
                                                  ),
                                                  column(width=2,br(),actionButton(ns("runONE"), "Calculate Residuals", icon = icon("play-circle")),br()),	  
												   uiOutput(ns("outStaRes2")),
                                           ),
                                           #column(width=3, numericInput(ns("outlierCoefOutqPheno"), label = "IQR coefficient", value = 5) ),
                                           column(width=12),
                                           shinydashboard::box(width = 12, status = "success",solidHeader=TRUE,collapsible = TRUE, collapsed = FALSE, title = "Visual aid (click on the '+' symbol on the right to open)",
                                                                      column(width=12,
                                                                             hr(style = "border-top: 3px solid #4c4c4c;"),
                                                                             h5(strong(span("The visualizations of the input-data located below will not affect your analysis but may help you pick the right input-parameters to be specified in the grey boxes above.", style="color:green"))),
                                                                             hr(style = "border-top: 3px solid #4c4c4c;"),
                                                                      ),
                                                                      tags$span(id = ns('holder1'),
                                                                                column(width=9, selectInput(ns("trait3Sta"), "Trait to visualize", choices = NULL, multiple = FALSE) ),
                                                                                # column(width=3, checkboxInput(ns("checkbox"), label = "Include x-axis labels", value = TRUE) ),
                                                                                column(width=3, numericInput(ns("transparency"),"Plot transparency",value=0.5, min=0, max=1, step=0.1) ),
                                                                                column(width=12, plotly::plotlyOutput(ns("plotPredictionsCleanOut"))  ), 
                                                                                column(width=12, plotly::plotlyOutput(ns("plotFieldGrid"))  ),
																				column(width=6,selectInput(ns("correlationType"),label = "Correlation Method:",choices = c("spearman","pearson","kendall") )),
                                                                                column(width=12, plotly::plotlyOutput(ns("plotCorrTrait"))  ),
                                                                      ),
                                                  ),
                                  ),#finish picktraits
                                  tabPanel(div(icon("dice-three"), "Residual analysis", icon("arrow-right") ), value = "ResAna",
                                     column(width=12,uiOutput(ns("warnRes"))),
									       shinydashboard::box(width = 12, status = "success",solidHeader=TRUE,collapsible = TRUE, collapsed = TRUE, title = "HELP!! (click on the '+' symbol on the right to open)",
                                                               column(width=12,
                                                                      hr(style = "border-top: 3px solid #4c4c4c;"),
                                                                      h5(strong(span("The following are graphical examples of classic patterns when analyzing model residuals, indicating that the data or model needs revision.", style="color:green"))),
                                                                      hr(style = "border-top: 3px solid #4c4c4c;"),
                                                               ),
                                                               column(width=12,
																	  selectInput(ns("diagnostic_example"),"Example:",choices = c("Nonlinearity","Heteroscedasticity","Outliers","High CookD","High Leverage", "NonNormality","Groups")),
																	  uiOutput(ns("diagnostic_image"))
															   )
															),
                                           shinydashboard::box(width = 12, status = "success",solidHeader=TRUE,collapsible = TRUE, collapsed = FALSE, title = "Visual aid (click on the '+' symbol on the right to open)",
                                                               column(width=12,
                                                                      hr(style = "border-top: 3px solid #4c4c4c;"),
                                                                      h5(strong(span("The visualizations of the input-data located below are interactive to select outliers based on residual analysis", style="color:green"))),
                                                                      hr(style = "border-top: 3px solid #4c4c4c;"),
                                                               ),
                                                               column(width=12,
                                                                      p(span("Preview of outliers that would be tagged using current input parameters above for trait selected.", style="color:black")),
                                                                      column(width=4, selectInput(ns("traitOutqPheno2"), "Trait to visualize", choices = NULL, multiple = FALSE)),
                                                                      column(width=4, selectInput(ns("EnvOutqPheno2"), "Enviroment to visualize", choices = NULL, multiple = FALSE)),
																	  #column(width=4, numericInput(ns("thrCook"),"Cook's Distances threshold",value=0.5, min=0, max=1, step=0.1) ),
                                                                      column(width=12,DT::DTOutput(ns("ResOut"))),
																	  br(),
																	  br(),
																	  column(width=12, plotly::plotlyOutput(ns("plotResidual"),height = "800px" ) )       
                                                               ),
															   textOutput(ns("outSta")),
                                           ),
                                  ),#finish panel residual
                                  tabPanel("Run analysis", icon = icon("dice-four"),
                                           br(),
                                           column(width=12,style = "background-color:grey; color: #FFFFFF",
                                                  column(width=3, tags$div(textInput(ns("analysisIdName"), label = tags$span(
                                                    "Analysis Name (optional)", tags$i( class = "glyphicon glyphicon-info-sign", style = "color:#FFFFFF",
                                                                                        title = "An optional name for the analysis besides the timestamp if desired.") ), #width = "100%",
                                                    placeholder = "(optional name)") ) ),
                                                  column(width=3,
                                                         br(),
                                                         actionButton(ns("runQaMb"), "Tag outliers", icon = icon("play-circle")),
                                                         br(),
                                                  )
                                           ),
                                           textOutput(ns("outQaMb")),
                                  ),
                                ) # end of tabset
                       ),# end of input panel
                       tabPanel(div(icon("arrow-right-from-bracket"), "Output tabs" ) , value = "outputTabs",
                                tabsetPanel(
                                  tabPanel("Dashboard", icon = icon("file-image"),
                                           br(),
                                           textOutput(ns("outQaMb2")),
                                           br(),
                                           downloadButton(ns("downloadReportQaPheno"), "Download dashboard"),
                                           br(),
                                           uiOutput(ns('reportQaPheno'))
                                  ),
                                ),
                       ), # end of output panel
                     )) # end mainpanel


  )
}

#' qaStaApp Server Functions
#'
#' @noRd
mod_qaStaApp_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    ############################################################################ clear the console
    hideAll <- reactiveValues(clearAll = TRUE)
    observeEvent(data(), {
      hideAll$clearAll <- TRUE
    })
    ############################################################################
    # warning message
    output$warningMessage <- renderUI(
      if(is.null(data())){
        HTML( as.character(div(style="color: red; font-size: 20px;", "Please retrieve or load your phenotypic data using the 'Data' tab.")) )
      }else{ # data is there
        mappedColumns <- length(which(c("environment","designation","trait") %in% data()$metadata$pheno$parameter))
        if(mappedColumns == 3){
          if("sta" %in% data()$status$module){
            HTML( as.character(div(style="color: green; font-size: 20px;", "Data is complete, please proceed to identify outliers specifying your input parameters under the 'Input' tabs.")) )
          }else{HTML( as.character(div(style="color: red; font-size: 20px;", "Please perform the single trial analysis before performing the QA model-based outlier detection.")) ) }
        }else{HTML( as.character(div(style="color: red; font-size: 20px;", "Please make sure that you have computed the 'environment' column, and that column 'designation' and \n at least one trait have been mapped using the 'Data Retrieval' tab.")) )}
      }
    )
    ## data example loading
    observeEvent(
      input$launch,
      if(length(input$launch) > 0){
        if (input$launch) {
          shinyWidgets::ask_confirmation(
            inputId = ns("myconfirmation"),
            text = "Are you sure you want to load the example data? This will delete any data currently in the environment.",
            title = "Data replacement warning"
          )
        }
      }
    )
    observeEvent(input$myconfirmation, {
      if (isTRUE(input$myconfirmation)) {
        shinybusy::show_modal_spinner('fading-circle', text = 'Loading example...')
        ## replace tables
        tmp <- data()
        data(cgiarBase::create_getData_object())
        utils::data(DT_example, package = "cgiarPipeline")
        if(!is.null(result$data)){tmp$data <- result$data}
        if(!is.null(result$metadata)){tmp$metadata <- result$metadata}
        if(!is.null(result$modifications)){tmp$modifications <- result$modifications}
        if(!is.null(result$predictions)){tmp$predictions <- result$predictions}
        if(!is.null(result$metrics)){tmp$metrics <- result$metrics}
        if(!is.null(result$modeling)){tmp$modeling <- result$modeling}
        if(!is.null(result$status)){tmp$status <- result$status}
        data(tmp) # update data with results
        shinybusy::remove_modal_spinner()
      }else{
        shinyWidgets::updatePrettySwitch(session, "launch", value = FALSE)
      }
    }, ignoreNULL = TRUE)
	
	#pick stamp
	observeEvent(c(data()), {
      req(data())
      dtSta <- data()
      dtSta <- dtSta$status
      dtSta <- dtSta[which(dtSta$module %in% c("qaRaw", "qaFilter", "qaMb", "qaDesign")),]
      traitsSta <- unique(dtSta$analysisId)
      if(length(traitsSta) > 0){
        if("analysisIdName" %in% colnames(dtSta)){
          names(traitsSta) <- paste(dtSta$analysisIdName, as.POSIXct(traitsSta, origin="1970-01-01", tz="GMT"), sep = "_")
        }else{
          names(traitsSta) <- as.POSIXct(traitsSta, origin="1970-01-01", tz="GMT")
        }
      }
      updateSelectInput(session, "version2qSta", choices = traitsSta)
    })
	observeEvent(c(data(),input$version2qSta), {
      req(data())
      req(input$version2qSta)
      # req(input$genoUnitOutqP)
      dtSta <- data()
      dtSta <- dtSta$modifications$pheno
      dtSta <- dtSta[which(dtSta$module %in% c("qaRaw", "qaMb")),]
      if(nrow(dtSta) > 0){
        dtSta <- dtSta[which(dtSta$analysisId %in% input$version2qSta),] # only traits that have been QA
        traitsQaMb <- unique(dtSta$trait)
        #updateSelectInput(session, "traitOutqPheno2",choices = traitsQaMb)
        updateSelectInput(session, "traitOutqPhenoMultiple", choices = traitsQaMb, selected = NULL)
		#shinyjs::hide(ns("traitOutqPheno2"))
      }
    })
   
   observeEvent(c(data(),input$version2qSta,input$traitOutqPhenoMultiple), {
      req(data())
      req(input$version2qSta)
      req(input$traitOutqPhenoMultiple)
      dtSta <- data()
      ped <- dtSta$data$pedigree
      colnames(ped) <- cgiarBase::replaceValues(colnames(ped),dtSta$metadata$pedigree$value, dtSta$metadata$pedigree$parameter)
      checkUnits <- apply(ped[,intersect(colnames(ped),c("designation", "mother","father")), drop=FALSE], 2, function(f){length(unique(f))})
      genetic.evaluation <- names(which(checkUnits > 1))
      # genetic.evaluation <- c("designation", "mother","father")
      updateSelectInput(session, "genoUnitOutqP",choices = genetic.evaluation, selected = "designation")
    })
     
    ## render timestamps flow
    output$plotTimeStamps <- shiny::renderPlot({
      req(data()) # req(input$version2qSta)
      xx <- data()$status;  yy <- data()$modeling # xx <- result$status;  yy <- result$modeling
      if("analysisIdName" %in% colnames(xx)){existNames=TRUE}else{existNames=FALSE}
      if(existNames){
        networkNames <- paste(xx$analysisIdName, as.character(as.POSIXct(as.numeric(xx$analysisId), origin="1970-01-01", tz="GMT")),sep = "_" )
        xx$analysisIdName <- as.character(as.POSIXct(as.numeric(xx$analysisId), origin="1970-01-01", tz="GMT"))
      }
      v <- which(yy$parameter == "analysisId")
      if(length(v) > 0){
        yy <- yy[v,c("analysisId","value")]
        zz <- merge(xx,yy, by="analysisId", all.x = TRUE)
      }else{ zz <- xx; zz$value <- NA}
      if(existNames){
        zz$analysisIdName <- cgiarBase::replaceValues(Source = zz$analysisIdName, Search = "", Replace = "?")
        zz$analysisIdName2 <- cgiarBase::replaceValues(Source = zz$value, Search = zz$analysisId, Replace = zz$analysisIdName)
      }
      if(!is.null(xx)){
        if(existNames){
          colnames(zz) <- cgiarBase::replaceValues(colnames(zz), Search = c("analysisIdName","analysisIdName2"), Replace = c("outputId","inputId") )
        }else{
          colnames(zz) <- cgiarBase::replaceValues(colnames(zz), Search = c("analysisId","value"), Replace = c("outputId","inputId") )
        }
        nLevelsCheck1 <- length(na.omit(unique(zz$outputId)))
        nLevelsCheck2 <- length(na.omit(unique(zz$inputId)))
        if(nLevelsCheck1 > 1 & nLevelsCheck2 > 1){
          X <- with(zz, enhancer::overlay(outputId, inputId))
        }else{
          if(nLevelsCheck1 <= 1){
            X1 <- matrix(ifelse(is.na(zz$inputId),0,1),nrow=length(zz$inputId),1); colnames(X1) <- as.character(na.omit(unique(c(zz$outputId))))
          }else{X1 <- model.matrix(~as.factor(outputId)-1, data=zz); colnames(X1) <- levels(as.factor(zz$outputId))}
          if(nLevelsCheck2 <= 1){
            X2 <- matrix(ifelse(is.na(zz$inputId),0,1),nrow=length(zz$inputId),1); colnames(X2) <- as.character(na.omit(unique(c(zz$inputId))))
          }else{X2 <- model.matrix(~as.factor(inputId)-1, data=zz); colnames(X2) <- levels(as.factor(zz$inputId))}
          mynames <- unique(na.omit(c(zz$outputId,zz$inputId)))
          X <- matrix(0, nrow=nrow(zz), ncol=length(mynames)); colnames(X) <- as.character(mynames)
          if(!is.null(X1)){X[,colnames(X1)] <- X1}
          if(!is.null(X2)){X[,colnames(X2)] <- X2}
        };
        rownames(X) <- networkNames
        colnames(X) <- networkNames
        if(existNames){

        }else{
          rownames(X) <-as.character(as.POSIXct(as.numeric(rownames(X)), origin="1970-01-01", tz="GMT"))
          colnames(X) <-as.character(as.POSIXct(as.numeric(colnames(X)), origin="1970-01-01", tz="GMT"))
        }
        # make the network plot
        n <- network::network(X, directed = FALSE)
        network::set.vertex.attribute(n,"family",zz$module)
        network::set.vertex.attribute(n,"importance",1)
        e <- network::network.edgecount(n)
        network::set.edge.attribute(n, "type", sample(letters[26], e, replace = TRUE))
        network::set.edge.attribute(n, "day", sample(1, e, replace = TRUE))
        library(ggnetwork)
        ggplot2::ggplot(n, ggplot2::aes(x = x, y = y, xend = xend, yend = yend)) +
          ggnetwork::geom_edges(ggplot2::aes(color = family), arrow = ggplot2::arrow(length = ggnetwork::unit(6, "pt"), type = "closed") ) +
          ggnetwork::geom_nodes(ggplot2::aes(color = family), alpha = 0.5, size=5 ) +
          ggnetwork::geom_nodelabel_repel(ggplot2::aes(color = family, label = vertex.names ),
                                          fontface = "bold", box.padding = ggnetwork::unit(1, "lines")) +
          ggnetwork::theme_blank() + ggplot2::ggtitle("Network plot of current analyses available")
      }
    })
    ## render the expected result

    ## render plot of trait distribution
        observeEvent(c(data(),input$version2qSta), { # update trait
          req(data())
          req(input$version2qSta)
          paramsPheno <- data()$metadata$pheno
          paramsPheno <- paramsPheno[which(!duplicated(paramsPheno$value)),]
          paramsPheno <- paramsPheno[which(paramsPheno$parameter != "trait"),]
          traitsSta <- setdiff(paramsPheno$parameter, c("trait","designation"))
          updateSelectInput(session, "feature", choices = traitsSta)
        })
        observeEvent(c(data(),input$version2qSta), { # update trait
          req(data())
          req(input$version2qSta)
          dtSta <- data()
          dtSta <- dtSta$modifications$pheno
          dtSta <- dtSta[which(dtSta$analysisId %in% input$version2qSta),] # only traits that have been QA
          traitsSta <- unique(dtSta$trait)
          updateSelectInput(session, "trait3Sta", choices = traitsSta)
        })
        output$plotPredictionsCleanOut <- plotly::renderPlotly({ # shiny::renderPlot({ #
          req(data())
          req(input$version2qSta)
          req(input$trait3Sta)
          mydata <- data()$data$pheno
          ### change column names for mapping
          paramsPheno <- data()$metadata$pheno
          paramsPheno <- paramsPheno[which(paramsPheno$parameter != "trait"),]
          colnames(mydata) <- cgiarBase::replaceValues(colnames(mydata), Search = paramsPheno$value, Replace = paramsPheno$parameter )
          ###
          mappedColumns <- length(which(c("environment","designation","trait") %in% data()$metadata$pheno$parameter))
          if(mappedColumns == 3){ # all required columns are present
            mydata$rowindex <- 1:nrow(mydata)
            mydata[, "environment"] <- as.factor(mydata[, "environment"]);mydata[, "designation"] <- as.factor(mydata[, "designation"])
            mo <- data()$modifications$pheno
            mo <- mo[which(mo[,"trait"] %in% input$trait3Sta),]
            mydata$color <- "valid"
            if(nrow(mo) > 0){mydata$color[which(mydata$rowindex %in% unique(mo$row))]="tagged"}
            mydata$predictedValue <- mydata[,input$trait3Sta]
            mydata <- mydata[,which(!duplicated(colnames(mydata)))]
            p <- ggplot2::ggplot(mydata, ggplot2::aes(x=predictedValue, fill=environment)) +
              ggplot2::geom_histogram(ggplot2::aes(y=ggplot2::after_stat(density)), position="identity", alpha=input$transparency ) +
              # ggplot2::geom_boxplot(fill='#A4A4A4', color="black", notch = TRUE, outliers = FALSE)+
              ggplot2::theme_classic() + ggplot2::ggtitle("Histogram of trait dispersion by environment") +
              # ggplot2::geom_jitter(ggplot2::aes(colour = color), alpha = 0.4) +
              ggplot2::ylab("Density") + ggplot2::xlab("Trait value") + ggplot2::scale_color_brewer(palette="Accent")
            # ggplot2::scale_color_manual(values = c(valid = "#66C2A5", tagged = "#FC8D62")) # specifying colors names avoids having valid points in orange in absence of potential outliers. With only colour = color, valid points are in orange in that case.
            # if(input$checkbox){
            #   p <- p + ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, vjust = 1))
            # }else{
            #   p <- p + ggplot2::theme(axis.text.x = ggplot2::element_blank())
            # }
            # p
            plotly::ggplotly(p)
          }else{}
        })
        # render fieldGrid heatmap
        output$plotFieldGrid <- plotly::renderPlotly({ # shiny::renderPlot({ #
          req(data())
          req(input$version2qSta)
          req(input$trait3Sta)
          mydata <- data()$data$pheno
          ### change column names for mapping
          paramsPheno <- data()$metadata$pheno
          paramsPheno <- paramsPheno[which(paramsPheno$parameter != "trait"),]
          colnames(mydata) <- cgiarBase::replaceValues(colnames(mydata), Search = paramsPheno$value, Replace = paramsPheno$parameter )
          ###
          mappedColumns <- length(which(c("environment","designation","trait") %in% data()$metadata$pheno$parameter))
          if(mappedColumns == 3){ # all required columns are present

            mappedCoordColumns <- length(which(c("row","col") %in% paramsPheno$parameter))
            if(mappedCoordColumns == 2){

              mydata$value <- mydata[, input$trait3Sta]
              maxVal <- max(mydata$value, na.rm = TRUE) # get the maximum value found in the matrix of connectivity
              minVal <- min(mydata$value, na.rm = TRUE) # get the maximum value found in the matrix of connectivity
              meanVal <- mean(mydata$value, na.rm = TRUE) # get the maximum value found in the matrix of connectivity

              if(!is.na(meanVal)){ # there is data
                pf <- ggplot2::ggplot(data = mydata, ggplot2::aes(row, col, fill = value))+
                  ggplot2::geom_tile(color = "white")+
                  ggplot2::scale_fill_gradient2(low = "#E46726", high = "#038542", mid = "gold",
                                                midpoint = meanVal, limit = c(minVal,maxVal), space = "Lab",
                                                name=input$trait3Sta) +
                  ggplot2::theme_minimal()+
                  ggplot2::ylab("") + ggplot2::xlab("") +
                  ggplot2::ggtitle("Field view")  +
                  ggplot2::facet_wrap(~environment, scales = "free") +
                  ggplot2::theme(axis.text.x = ggplot2::element_blank(), axis.text.y = ggplot2::element_blank() )
                plotly::ggplotly(pf)
              }
            }

          }else{}
        })

#plot of correlations

     cor_pval_matrix <- function(df, method = "spearman", conf.level = 0.95) {
      traits <- colnames(df)
      n <- length(traits)

      cor.mat <- matrix(NA, nrow = n, ncol = n, dimnames = list(traits, traits))
      p.mat <- matrix(NA, nrow = n, ncol = n, dimnames = list(traits, traits))

      for (i in seq_len(n)) {
        for (j in seq_len(n)) {
          if (i != j) {
            complete_idx <- complete.cases(df[[i]], df[[j]])
            x <- df[[i]][complete_idx]
            y <- df[[j]][complete_idx]

            if (length(x) >= 3) {
              test <- cor.test(x, y, method = method, conf.level = conf.level)
              cor.mat[i, j] <- test$estimate
              p.mat[i, j] <- test$p.value
            }
          } else{
            cor.mat[i, j] <- 1
            p.mat[i, j] <- 0
          }
        }
      }
      return(list(cor = cor.mat, p = p.mat))
    }
	
    output$plotCorrTrait <- plotly::renderPlotly({
      req(data())
      req(input$traitOutqPhenoMultiple)
      req(input$correlationType)
      # Check if there are more than one selected traits
      req(length(input$traitOutqPhenoMultiple) > 1)
      #mydata <- filtered_data()
      mydata <- data()$data$pheno
      if(length(input$traitOutqPhenoMultiple) > 1){
        df_num <- dplyr::select(mydata[, input$traitOutqPhenoMultiple, drop = FALSE], where(is.numeric))
        p.mat <- cor_pval_matrix(df_num, method = input$correlationType, conf.level = 0.95)
        # Barring the no significant coefficient
        g<-ggcorrplot::ggcorrplot(p.mat$cor, hc.order = TRUE, type = "lower", p.mat = p.mat$p, lab=T,
                                  colors = c("#E46726", "white", "#038542"), show.diag = T)
        plotly::ggplotly(g)
      } else {
        print("Select more than one!")
      }
    }
    )

#Start calculate residuals
## reactiveValues GLOBAL del server
rv <- reactiveValues(allRes = NULL)

#----------------------------------------------------------
# BOTON
#----------------------------------------------------------
observeEvent(input$runONE, {

  req(data())
  req(input$version2qSta)
  req(input$traitOutqPhenoMultiple)
  req(input$genoUnitOutqP)

  shinybusy::show_modal_spinner('fading-circle',text = 'Processing...')
	dtSta <- data()
	#source("C:/Users/RAPACHECO/OneDrive - CIMMYT/Documents/CIMMYT/2026/Bioflow/resMod.R")
	#source("C:/Users/RAPACHECO/OneDrive - CIMMYT/Documents/CIMMYT/2026/Bioflow/pplotmod.R")
	res <- try(
		cgiarPipeline::resMod(
		phenoDTfile = dtSta,
		analysisId = input$version2qSta,
		trait = input$traitOutqPhenoMultiple,
		genoUnit = input$genoUnitOutqP,
		addRes=FALSE,
		verbose = TRUE
		),
		silent = TRUE
	)
	updateTabsetPanel(session,"tabInput",selected = "ResAna")
  shinybusy::remove_modal_spinner()
 
  if(!inherits(res, "try-error")) {
    updateSelectInput(session, "traitOutqPheno2", choices = unique(res$trait), selected = unique(res$trait)[1])
    updateSelectInput(session, "EnvOutqPheno2", choices = unique(res$environment), selected = unique(res$environment)[1])
	#updateNumericInput(session, "thrCook", value=unique(res$thr)[1])
    rv$allRes <- res
    rv$allRes$idRow <- seq_len(nrow(rv$allRes))
	output$outStaRes2 <- renderUI({  tags$div(  style = " font-size:18px; font-weight:bold; color:white; padding:10px;",
		'Ready!!, please go to the next tab "Residual analysis"')})
  } else {
    output$outStaRes2 <- renderUI({  tags$div(  style = " font-size:18px; font-weight:bold; color:white; padding:10px;",
	    " Analysis fail ")})
  }

})
#----------------------------------------------------------
#  EXAMPLES
#----------------------------------------------------------
output$diagnostic_image <- renderUI({

  file <- switch(
    input$diagnostic_example,
    "Nonlinearity"      = "www/caso1.png",
    "Heteroscedasticity"= "www/caso2.png",
    "Outliers"          = "www/caso3.png",
	  "High CookD"        = "www/caso4.png",
    "High Leverage"     = "www/caso5.png",
    "NonNormality"      = "www/caso6.png",
	  "Groups"            = "www/caso7.png"
  )

  img(src = file, width = "100%")
})

#----------------------------------------------------------
# TABLA
#----------------------------------------------------------
output$ResOut <- DT::renderDT({

  req(rv$allRes)
  req(input$traitOutqPheno2)
  req(input$EnvOutqPheno2) 

  tmpRes <- rv$allRes[
    rv$allRes$trait == input$traitOutqPheno2 &
    rv$allRes$environment == input$EnvOutqPheno2,
  ]

  names(tmpRes)[15]="outlier (editable)"
  numeric_output <- c("Observed","fitted","residuals","cookD","leverage","stdt","N","p")
comp=data.frame(rv$allRes)
  #save(comp,file="revisar.RData")
  DT::formatRound( DT::datatable(tmpRes, editable = list(target = "cell", disable = list(columns = c(0:14,16:17))),
      options = list(dom = 'Blfrtip',scrollX = TRUE, buttons = c('copy','csv','excel','pdf'),
        lengthMenu = list(c(10,20,50,-1), c(10,20,50,'All')),
		columnDefs = list(list(targets = 15,createdCell = htmlwidgets::JS("function(td, cellData, rowData, row, col) {$(td).attr('title','Editable column: double click to modify');}")))    
		)),numeric_output)|>  
  DT::formatStyle('outlier (editable)',backgroundColor = DT::styleEqual( c("GOOD","outlier"), c("#A4D65E","#FF7F7F")))|>
  DT::formatStyle('outlierFinal',backgroundColor = DT::styleEqual( c("GOOD","outlier"), c("#A4D65E","#FF7F7F")))
  
})

#----------------------------------------------------------
# EDICION DE TABLA
#----------------------------------------------------------
observeEvent(input$ResOut_cell_edit, {

  req(rv$allRes)
  info <- input$ResOut_cell_edit

  i <- info$row
  j <- info$col + 1
  v <- info$value

  tmpRes <- rv$allRes[
    rv$allRes$trait == input$traitOutqPheno2 &
    rv$allRes$environment == input$EnvOutqPheno2,
  ]

  real_id <- tmpRes$idRow[i]

  real_row <- which(rv$allRes$idRow == real_id)

  if(v %in% c("GOOD", "outlier")) { rv$allRes[real_row, "outlierFinal"] <- v}

})

#----------------------------------------------------------
# GRAFICO
#----------------------------------------------------------
output$plotResidual <- plotly::renderPlotly({

  req(rv$allRes)
  req(input$traitOutqPheno2)
  req(input$EnvOutqPheno2)

  tmpResP <- rv$allRes[
    rv$allRes$trait == input$traitOutqPheno2 &
    rv$allRes$environment == input$EnvOutqPheno2,
  ]
  tmpResP$outlier<-tmpResP$outlierFinal
  cgiarPipeline::pplotmod(df = tmpResP)  
})

#----------------------------------------------------------
# warning
#----------------------------------------------------------
output$warnRes <- renderUI({

  req(rv$allRes)
  req(input$traitOutqPheno2)
  req(input$EnvOutqPheno2)

  tmpResP <- rv$allRes[
    rv$allRes$trait == input$traitOutqPheno2 &
    rv$allRes$environment == input$EnvOutqPheno2,
  ]

  if(length(which(tmpResP$outlier == "outlier")) >= (nrow(tmpResP) * 0.15)) {  

    div(
      style = "
        color:#856404;
        background-color:#fff3cd;
        border:1px solid #ffeeba;
        padding:15px;
        border-radius:5px;
        font-weight:500;
      ",

      strong("Warning: "),
      
      "A large proportion of observations have been flagged as outliers, ",
      "indicating non-normal residuals. Apply a variance-stabilising ",
      "transformation (log, square-root, Box-Cox) and refit. ",
      "If the issue persists, consider excluding this trait ",
      "or environment from the analysis."

    )

  }

})

    outQaMb <- eventReactive(input$runQaMb, {      
        req(data())
		req(rv$allRes)
        
		shinybusy::show_modal_spinner('fading-circle', text = 'Processing...')
        ## get the outlier table
        tmpOut<-rv$allRes[which(rv$allRes$outlierFinal=="outlier"),]          
		if(nrow(tmpOut) > 0){
          ## get data structure
          result <- data()
          ## update analsisId in the outliers table
          analysisId <- as.numeric(Sys.time())       
		  modificar<-data.frame(cbind("qaMb",as.POSIXct(analysisId, origin="1970-01-01", tz="GMT"),tmpOut[,"trait"],"outlierRes",tmpOut[,"idRowR"],tmpOut[,"Observed"]))
		  names(modificar)<-c("module","analysisId","trait","reason","row","value")
          result$modifications$pheno <- rbind(result$modifications$pheno, modificar)
		  df<-data.frame(rv$allRes)
		  df_unique <- df %>% dplyr::distinct(trait, environment, .keep_all = TRUE)
		  newParamsPheno<-data.frame(cbind("qaMb",as.POSIXct(analysisId, origin="1970-01-01", tz="GMT"),df_unique$trait,df_unique$environment,"cookD",round(4/unique(df_unique$N),4)))
		  names(newParamsPheno)<-c("module","analysisId","trait","environment","parameter","value")
		  parms2<-data.frame(cbind("qaMb",as.POSIXct(analysisId, origin="1970-01-01", tz="GMT"),df_unique$trait,df_unique$environment,"leverage",round((2*unique(df_unique$p))/unique(df_unique$N),4)))
		  names(parms2)<-c("module","analysisId","trait","environment","parameter","value")          
		  newParamsPheno<-rbind(newParamsPheno,parms2)
		  names(newParamsPheno)<-c("module","analysisId","trait","environment","parameter","value")          
          result$modeling <- rbind(result$modeling, newParamsPheno)
          newStatus <- data.frame(module="qaMb", analysisId=analysisId, analysisIdName=input$analysisIdName)
          result$status <- rbind(result$status, newStatus)
		  data(result)
        }
		res2 <- try(
		  cgiarPipeline::resMod(
			  phenoDTfile = result,
			  analysisId = input$version2qSta,
			  trait = input$traitOutqPhenoMultiple,
			  genoUnit = input$genoUnitOutqP,	
			  addRes=TRUE,
			  verbose = TRUE
		),
		silent = TRUE
		)
		#save(res2,file="rerun2.RData")
		predRes<-data.frame(cbind("qaMb",as.POSIXct(analysisId, origin="1970-01-01", tz="GMT"),res2$idRowR,as.character(res2$trait),paste0(res2$N,"_",res2$p),as.character(res2$designation),res2$repF,res2$stdt,res2$outlierFinal,
							as.character(res2$environment),res2$fitted,res2$residuals,res2$cookD,res2$leverage))
		names(predRes)<-c("module","analysisId","pipeline","trait","gid","designation","mother","father","entryType","environment","predictedValue","stdError","reliability","effectType")
		result$predictions <- rbind(result$predictions, predRes)
		data(result)
        cat(paste("Modifications to phenotype information saved with id:",as.POSIXct( analysisId, origin="1970-01-01", tz="GMT")))
        #save(result,file="rerun.RData")
        updateTabsetPanel(session, "tabsMain", selected = "outputTabs")
        shinybusy::remove_modal_spinner()

        if(!inherits(result,"try-error")) { # if all goes well in the run
          # ## Report tab		  
          output$reportQaPheno <- renderUI({
            HTML(markdown::markdownToHTML(knitr::knit(system.file("rmd","reportQaPheno.Rmd",package="bioflow"), quiet = TRUE), fragment.only=TRUE))
          })

          output$downloadReportQaPheno <- downloadHandler(
            filename = function() {
              paste(paste0('qaSta_dashboard_',gsub("-", "", Sys.Date())), sep = '.', switch(
                "HTML", PDF = 'pdf', HTML = 'html', Word = 'docx'
              ))
            },
            content = function(file) {
              src <- normalizePath(system.file("rmd","reportQaPheno.Rmd",package="bioflow"))
              src2 <- normalizePath('data/resultQaPheno.RData')
              # temporarily switch to the temp dir, in case you do not have write
              # permission to the current working directory
              owd <- setwd(tempdir())
              on.exit(setwd(owd))
              file.copy(src, 'report.Rmd', overwrite = TRUE)
              file.copy(src2, 'resultQaPheno.RData', overwrite = TRUE)
              shinybusy::show_modal_spinner('fading-circle', text = 'Processing...')
              out <- rmarkdown::render('report.Rmd', params = list(toDownload=TRUE),switch(
                "HTML",
                HTML = rmdformats::robobook(toc_depth = 4)
                # HTML = rmarkdown::html_document()
              ))
              shinybusy::remove_modal_spinner()
              file.rename(out, file)
            }
          )

          output$outQaMb2 <- renderPrint({
            cat(paste("Modifications to phenotype information saved with id:",as.POSIXct( analysisId, origin="1970-01-01", tz="GMT")))
          })

        }else{ hideAll$clearAll <- TRUE}

        hideAll$clearAll <- FALSE
      
    })

    output$outQaMb <- renderPrint({
      outQaMb()
    })

  })
}

## To be copied in the UI
# mod_qaStaApp_ui("qaStaApp_1")

## To be copied in the server
# mod_qaStaApp_server("qaStaApp_1")
