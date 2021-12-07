library(dplyr)

############SeoulPopulation18-21#############
SeoulPop<-read.csv("SeoulPopulation18-21.csv")

## 결측치 확인
sum(is.na(SeoulPop))

## 필요한 열 선택 및 열이름 변환
SeoulPop<-select(SeoulPop, 기준일=기준일ID, id=자치구코드, 총생활인구수)
str(SeoulPop)

## 필요한 행만 선택
SeoulPop <- SeoulPop[SeoulPop$기준일>=20190101,]
str(SeoulPop)

SeoulPop$year<-substr(SeoulPop$기준일,1,4) ##년도 추출
View(SeoulPop)
sum_pop<-SeoulPop%>%
  group_by(id, year)%>%
  summarise(sum_population=sum(총생활인구수))
View(sum_pop)



############두 데이터프레임 합치기#############
Wifi_year_cum<-read.csv("Wifi_year_cum.csv")
View(Wifi_year_cum)

wifi_pop<-merge(sum_pop, Wifi_year_cum, by.x=c("id","year"), by.y=c("id","설치년도"))
wifi_pop<-subset(wifi_pop, select=-X) ##필요없는 변수 삭제
wifi_pop<-wifi_pop%>%
  mutate(ratio=cum_count/sum_population) ##생활인구 수 대비 설치 수 변수 추가
View(wifi_pop)

save(wifi_pop, file="wifi_pop.rda")