#' Launch Manual Review Shiny App for Name Matching Candidates
#'
#' This function launches a Shiny interface for manually approving or rejecting
#' name matching candidates generated in advance by `match_names_sbert()`.
#' It loads the `match_result.csv` file and allows the user to interactively
#' judge the similarity-based matches. The results are saved to `nayose_dict.csv`,
#' which can be reused for future automatic name matching.
#'
#' @return None. Launches the Shiny app; results are saved to a CSV file via manual operation.
#' @importFrom shiny fluidPage titlePanel sidebarLayout sidebarPanel sliderInput
#'   actionButton mainPanel DTOutput reactiveVal renderDT observeEvent shinyApp showNotification
#' @importFrom DT datatable renderDT
#' @importFrom utils read.csv write.csv
#' @export
launch_nayose_app <- function() {
  ui <- shiny::fluidPage(
    shiny::titlePanel("Manual Review of Name Matching Candidates"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::sliderInput("threshold", "Similarity Threshold", min = 0.5, max = 1, value = 0.75, step = 0.01),
        shiny::actionButton("save_csv", "Save")
      ),
      shiny::mainPanel(
        DT::DTOutput("table"),
        shiny::actionButton("approve", "Approve"),
        shiny::actionButton("reject", "Reject"),
        DT::DTOutput("confirmed_table")
      )
    )
  )

  server <- function(input, output, session) {
    match_df <- shiny::reactiveVal(utils::read.csv("match_result.csv", stringsAsFactors = FALSE))
    confirmed <- shiny::reactiveVal(data.frame(name_a = character(), name_b = character(), similarity = numeric(), status = character()))

    output$table <- DT::renderDT({
      filtered <- match_df()[match_df()$similarity >= input$threshold, ]
      DT::datatable(filtered, selection = "single")
    })

    shiny::observeEvent(input$approve, {
      selected <- input$table_rows_selected
      if (length(selected) > 0) {
        row <- match_df()[selected, ]
        row$status <- "approved"
        confirmed(rbind(confirmed(), row))
      }
    })

    shiny::observeEvent(input$reject, {
      selected <- input$table_rows_selected
      if (length(selected) > 0) {
        row <- match_df()[selected, ]
        row$status <- "rejected"
        confirmed(rbind(confirmed(), row))
      }
    })

    shiny::observeEvent(input$save_csv, {
      utils::write.csv(confirmed(), "nayose_dict.csv", row.names = FALSE)
      shiny::showNotification("Saved successfully!")
    })

    output$confirmed_table <- DT::renderDT({
      DT::datatable(confirmed())
    })
  }

  shiny::shinyApp(ui, server)
}
