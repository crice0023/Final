
library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(dplyr)

# Define UI for application
ui <- dashboardPage(
  dashboardHeader(title = "EVS Data Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Overview",
        tabName = "overview",
        icon = icon("info-circle")
      ),
      menuItem("Exploration", tabName = "exploration", icon = icon("search")),
      menuItem(
        "Regression",
        tabName = "regression",
        icon = icon("chart-line")
      ),
      selectInput(
        "country",
        "Country",
        choices = c(
          "Overall",
          "Albania",
          "Azerbaijan",
          "Austria",
          "Armenia",
          "Bosnia and Herzegovina",
          "Bulgaria",
          "Belarus",
          "Croatia",
          "Czechia",
          "Denmark",
          "Estonia",
          "Finland",
          "France",
          "Georgia",
          "Germany",
          "Hungary",
          "Iceland",
          "Italy",
          "Latvia",
          "Lithuania",
          "Montenegro",
          "Netherlands",
          "Norway",
          "Poland",
          "Portugal",
          "Romania",
          "Russia",
          "Serbia",
          "Slovakia",
          "Slovenia",
          "Spain",
          "Sweden",
          "Switzerland",
          "Ukraine",
          "North Macedonia",
          "Great Britain"
        ),
        selected = "Overall"
      ),
      selectInput(
        "outcome",
        "Outcome",
        choices = list(
          "Child suffers when the mother works" = "child_suffer",
          "Job should be given to a national" = "job_national"
        ),
        selected = "child_suffer"
      ),
      checkboxGroupInput(
        "controls",
        "Controls",
        choices = c("sex" = "Sex", "edu" = "Education")
      ),
      sliderInput(
        "agePoly",
        "Age Polynomial Degree",
        min = 1,
        max = 5,
        value = 1
      ),
      downloadButton("downloadReport", "Download Report")
    )
  ),
  dashboardBody(tabItems(
    tabItem(
      tabName = "overview",
      h2("Overview of the Application"),
      p(
        "This application allows users to explore and analyze attitudes towards gender roles and immigrants using EVS data. Navigate through the tabs to explore different aspects of the data."
      ),
      p(
        "For any data or application questions specific to this topic, please contact Chris Rice at crice127@umd.edu"
      ),
      p("THANKS FOR STOPPING BY!!!")
    ),
    tabItem(
      tabName = "exploration",
      box(
        title = "Outcome and Controls Exploration",
        status = "primary",
        solidHeader = TRUE,
        plotOutput("outcomePlot"),
        width = 12
      )
    ),
    tabItem(tabName = "regression",
            fluidRow(
              box(
                title = "Regression Results",
                status = "warning",
                solidHeader = TRUE,
                DTOutput("regressionOutput")
              )
            ),
            fluidRow(
              box(
                title = "Residuals vs Fitted",
                status = "warning",
                solidHeader = TRUE,
                plotOutput("residualPlot")
              )
            ))
  ))
)

library(rmarkdown)

server <- function(input, output) {
  # local# data <- readRDS("C:/Users/ricecakes/Desktop/Git1/Final/Final/Final_Shiny/data_clean.rds")
  # Load data from the .rds file
  data <- readRDS("data_clean.rds")
  
  filteredData <- reactive({
    df <- if (input$country != "Overall") {
      data %>% filter(cntry == input$country)
    } else {
      data
    }
    if ("sex" %in% input$controls) {
      df <- df %>% filter(sex %in% c("Male", "Female"))
    }
    if ("edu" %in% input$controls) {
      df <- df %>% filter(edu %in% c("Lower", "Medium", "Higher"))
    }
    df
  })
  
  output$outcomePlot <- renderPlot({
    plot_data <- filteredData()
    plot_data <- plot_data %>%
      mutate(
        child_suffer = as.factor(child_suffer),
        job_national = as.factor(job_national)
      )
    if (input$outcome == "child_suffer") {
      ggplot(plot_data, aes(x = age, y = child_suffer)) +
        geom_boxplot() +
        labs(title = "Child Suffering by Age", x = "Age", y = "Level of Response") +
        theme_minimal()
    } else {
      ggplot(plot_data, aes(x = job_national, y = age)) +
        geom_boxplot() +
        labs(title = "Age Distribution by Job National Response", x = "Job National Response", y = "Age") +
        theme_minimal()
    }
  })
  
  reactiveData <- reactive({
    df <- filteredData()
    if (input$outcome == "child_suffer") {
      df$child_suffer <- as.numeric(as.character(df$child_suffer))
    } else {
      df$job_national <- as.numeric(as.character(df$job_national))
    }
    formula_str <- paste(
      input$outcome,
      "~ poly(age, ", input$agePoly, ")",
      if ("sex" %in% input$controls) "+ sex" else "",
      if ("edu" %in% input$controls) "+ edu" else ""
    )
    tryCatch({
      model <- lm(as.formula(formula_str), data = df)
      if(sum(is.na(model$fitted.values)) < nrow(df)) {
        return(model)
      } else {
        stop("Model fitting resulted in NaN values.")
      }
    }, error = function(e) {
      message("Error in fitting model: ", e$message)
      return(NULL)
    })
  })
  
  # Using DT to render the regression model summary as an interactive table
  output$regressionOutput <- renderDataTable({
    model <- reactiveData()
    if (is.null(model)) {
      data.frame(Error = "Model could not be computed due to data or formula issues.")
    } else {
      df <- broom::tidy(model)
      datatable(df, options = list(pageLength = 5, autoWidth = TRUE, columnDefs = list(list(targets = '_all', render = JS(
        "function(data, type, row, meta){
          return type === 'display' ? parseFloat(data).toFixed(3) : data;
        }"
      )))))
    }
  })
  
  output$residualPlot <- renderPlot({
    model <- reactiveData()
    if (!is.null(model)) {
      plot(residuals(model) ~ fitted(model), main = "Residuals vs Fitted Values")
    } else {
      print("No valid model data available for plotting.")
    }
  })
  # Add downloadHandler to generate the report
  output$downloadReport <- downloadHandler(
    filename = function() {
      paste("EVS-data-analysis-", Sys.Date(), ".pdf", sep = "")
    },
    content = function(file) {
      params <- list(
        plot1 = output$outcomePlot(),
        plot2 = output$residualPlot(),
        regModel = output$regressionOutput(),
        resPlot = output$residualPlot()
      )
      
      rmarkdown::render("C:/Users/ricecakes/Desktop/Git1/Final/Final/Final_Shiny/EVS PDF.Rmd", 
                        output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    })

}
shinyApp(ui, server)