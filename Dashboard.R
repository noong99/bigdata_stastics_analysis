# 3. 시각화 및 대시보드(Rshiny) - 인사이트 도출 ####
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(wordcloud)
library(wordcloud2)
library(RColorBrewer)
library(stringr)
library(dplyr)

load("Wifi_map_merge.rda")
load("gu_count.rda")
load("wifi_pop.rda")
load("SeoulWifi.rda")
gu_name<-read.csv("gu_name.csv")
pop_rank5<-read.csv("pop_rank5.csv")

create_wordcloud <- function() {
  radius=gu_count$총생활인구수 
  pal<-brewer.pal(8,"Dark2")
  set.seed(123)
  wordcloud<-wordcloud(words=gu_count$name,freq=radius,random.order=F,rot.per=.1,colors=pal)
  return(wordcloud)
}

create_treemap <- function() {
  library(treemap)
  treemap<-treemap(gu_count,
                   index="name",
                   vSize="총생활인구수", 
                   vColor="총생활인구수", 
                   type="value", 
                   bg.labels="yellow",fontfamily.labels="AppleGothic") 
  return(treemap)
}

ui <- dashboardPage(
  dashboardHeader(title="생활인구수를 통한 와이파이 추가적인 설치 필요 지역 탐색", titleWidth=600),
  dashboardSidebar(
    sidebarMenu(
      menuItem("EDA", tabName = "EDA",icon=icon("bar-chart-o")),
      menuItem("INSIGHT", tabName="INSIGHT",icon=icon("list-alt"))
    )
  ),
  dashboardBody(
    tabItems(
      # 첫번째 tab content
      tabItem(tabName = "EDA",
              fluidRow(h3("  -서울시 공공와이파이 서비스 위치 정보"),
                       column(6,
                              box(title="년도에 따른 공공와이파이 설치 현황", status="primary", solidHeader=TRUE,
                                  plotOutput(outputId = "Wifi_timeseries", width="100%"), width=10)
                       ),
                       
                       column(6,                
                              box(selectInput(inputId = "year",
                                              "Select year",
                                              width="20%",
                                              list(2019,2020,2021)),
                                  title="서울시 자치구별 공공와이파이",status="primary", solidHeader=TRUE, collapsible=TRUE,
                                  plotOutput(outputId = "map", width="100%"),width=10)),
              ),
              
              fluidRow(h3(" - 행정동별 서울생활인구(내국인)"),
                       column(6,                     
                              box(radioButtons(inputId = "graph",
                                               "Graph Type",width="100%",
                                               choices=c("WordCloud","TreeMap")),
                                  title="서울시 자치구별 유동인구", status="primary",solidHeader=TRUE,collapsible=TRUE,
                                  plotOutput(outputId = "graph_out", width="100%"), width=10)),
                       column(6, offset=-10,
                              box(title="서울시 내 자치구 총생활인구 top5 ", status="primary",solidHeader=TRUE,collapsible=TRUE,
                                  plotOutput(outputId = "pieChart", width = "100%"), width=10))
              )
      )
      #두번째 tap content
      ,tabItem(tabName = "INSIGHT",
               fluidRow(h3(" - 각 연도 wifi설치 현황과 생활인구 현황(참고자료) 비교"),
                        column(width = 2,
                               box(radioButtons(inputId = "popwifi", # 누적x wifi랑 생활인구그래프
                                                "Select year",width=300,
                                                choices=c("2019년","2020년","2021년")),width=20, status="primary")),
                        column(width=9,
                               box(title="해당 연도 wifi설치 개수",status="primary",collapsible=TRUE,
                                   imageOutput("nocum", height = "80%"),width = 100 ))), # 누적안한 그래프
               fluidRow(width=10,
                        column(width=9, offset=2,
                               box(title="해당 연도 총생활인구 (참고자료 기반)",status = "primary",collapsible=TRUE,
                                   imageOutput("pop", height = "70%"),width=100))), # 생활인구 그래프
               br(),
               hr(),   
               fluidRow(h3(" - 공공와이파이, 생활인구 데이터 통합 결과"),
                        column(width=10,
                               box(width=100,
                                   selectInput(inputId = "year_i",
                                               "Select year",
                                               width="25%",
                                               list(2019,2020,2021)),
                                   title="생활인구 수 대비 공공와이파이 설치 수",status="primary",collapsible=TRUE,
                                   plotOutput(outputId = "ratio", width = 1300))),
                        column(width=2,
                               box(title="Top 5",status="primary",solidHeader = TRUE, collapsible = TRUE,
                                   tableOutput(outputId = "top")),
                               box(title="Least 5",status="primary",solidHeader = TRUE, collapsible = TRUE,
                                   tableOutput(outputId = "least"))
                        )
               )
      )
    )
  )
)


server <- function(input, output) {
  plot <- reactive({
    ggplot() + geom_polygon(data = merge[merge$설치년도==input$year,], aes(x=long, y=lat, group=group, fill = cum_count)) +
      labs(fill="설치 누적 개수")+
      geom_text(data=gu_name, aes(x=long, y=lat, label=gu))+
      scale_fill_gradient(low = "#ffe5e5", high = "#ff3232", space = "Lab", guide = "colourbar") +
      coord_map()+
      ggtitle(label=input$year)+
      theme(plot.title=element_text(hjust=0.5, face='bold'))
  })
  output$Wifi_timeseries=renderPlot({
    gu_year <- SeoulWifi.df %>% 
      group_by(설치년도) %>% 
      summarise(누적설치수 = sum(n()))
    ggplot(data = gu_year, aes(x = 설치년도, y = 누적설치수, ymax = 누적설치수 + 500)) + geom_line() + geom_point(size=3.5, colour = "darkgreen")+
      geom_text(mapping=aes(label = 누적설치수, fontface='bold'),vjust=-1.2) + theme_minimal()+
      theme(plot.title=element_text(face="bold",hjust=0.5,size=15,color = "darkgreen")) + scale_color_brewer(palette= "BrBG")
  })
  
  ## WordCloud, Treemap
  output$map=renderPlot({
    print(plot())
  })
  output$graph_out=renderPlot({
    if (input$graph=="WordCloud") {
      create_wordcloud()
    }
    if (input$graph=="TreeMap") {
      create_treemap()
    }
  })
  
  ## Piechart
  output$pieChart <- renderPlot({
    circle <- table(pop_rank5$name)
    label <- paste(pop_rank5$name, "\n", pop_rank5$sum_population)
    pie(circle, labels=label)
  })
  
  ## 2019, 2020, 2021 비교 그래프
  output$nocum=renderImage({
    if (input$popwifi=="2019년") {
      list(src = "2019년wifi(누적x).jpeg")
    }
    else if (input$popwifi=="2020년") {
      list(src = "2020년wifi(누적x).jpeg")
    }
    else if (input$popwifi=="2021년")
      list(src = "2021년wifi(누적x).jpeg")
  }, deleteFile = FALSE)
  
  output$pop=renderImage({
    if (input$popwifi=="2019년") {
      list(src = "2019년서울생활인구.JPG")
    }
    else if (input$popwifi=="2020년") {
      list(src = "2020년서울생활인구.JPG")
    }
    else if (input$popwifi=="2021년")
      list(src = "2021년서울생활인구.JPG")
  }, deleteFile = FALSE)
  
  output$ratio=renderPlot({
    y=input$year_i
    ggplot(wifi_pop[wifi_pop$year==y,], aes(x=reorder(자치구,-ratio), y=ratio, fill=자치구))+geom_bar(stat="identity", width=0.8)+
      ggtitle(paste(input$year_i,"년"))+xlab("자치구")+ylab("누적 설치 수/생활인구 수")+
      theme(plot.title=element_text(hjust=0.5))+
      theme(axis.text.y = element_blank())+
      theme_bw()
  })
  output$least=renderTable({
    wifi_pop_y<-wifi_pop[wifi_pop$year==2021,]
    wifi_pop_order<-wifi_pop_y[order(wifi_pop_y$ratio, decreasing = FALSE),]
    wifi_pop_order[1:5,4]}, colnames = FALSE, align = "c"
  )
  output$top=renderTable({
    wifi_pop_y<-wifi_pop[wifi_pop$year==2021,]
    wifi_pop_order<-wifi_pop_y[order(wifi_pop_y$ratio, decreasing = TRUE),]
    wifi_pop_order[1:5,4]}, colnames = FALSE
  )
}

shinyApp(ui=ui, server=server)
