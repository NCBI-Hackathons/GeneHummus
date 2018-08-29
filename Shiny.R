library(shiny)
library(shinythemes)
ui <- fluidPage(
   theme = shinytheme("flatly"),
   titlePanel("Auxin Response Factors (ARFs) in Legumes"),
   p("Find ARFs in your favorite legume species"),
   sidebarLayout(      
      sidebarPanel(
         selectInput("species", label = h3("Select your species of interest"), 
         choices = c("Cicer arietinum", "Medicago truncatula", "Glycine max", "Lupinus angustifolius", "Arachis duranensis", "Arachis ipaensis", "Cajanus cajan", "Vigna angularis","Vigna radiata","Phaseolus vulgaris")),
         downloadButton("DownloadTable", "Download")),
      mainPanel(
         tableOutput("table") 
      )
   )
)

server <- function(input, output) {
   load("shinyARFlegumes.Rdata")
   Table1<-reactive({
      x=as.data.frame(my_tables[input$species])
      names(x)=c("XP", "LOC","Chr","chr_s","chr_e","AA","mol_wt","exon")
      x
      }
   )
   output$table = renderTable({Table1()})
   output$DownloadTable <- downloadHandler(
      filename = function(){paste(input$species,"_ARF.csv", sep = "")},
      content = function(file){write.csv(Table1(), file)
      }
   )
}
shinyApp(ui, server)
