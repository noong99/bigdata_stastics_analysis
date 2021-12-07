library(XML)
library(RCurl)
library(dplyr)

# 1. 데이터 수집 - API 스크래핑 ####
# 행정동별 서울생활인구(내국인) ####
url<-"http://openapi.seoul.go.kr:8088"
myKey<-"494c547a6a796f6f38325944585859"
StartIndex=1
EndIndex=1
month=202111

start<-seq(from=1, to=10176, by=1000) # 11월 28일까지 데이터 10176*=284928개
df_pop<-data.frame()
daylist <- c("01","02","03","04","05","06","07","08","09",10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28)

for (day in daylist){
  for (StartIndex in start) {
    EndIndex=StartIndex+999 #한번 요청할 때 1000을 넘지 못함
    myURL<-paste(url,"/",myKey,"/xml/SPOP_LOCAL_RESD_DONG/",StartIndex,"/",EndIndex,sep="","/",month,day)
    myxml<-getURL(myURL)
    myxml<-xmlParse(myxml)
    xmlRoot(myxml)
    temp<-xmlToDataFrame(getNodeSet(myxml,'//row'))
    df_pop<-rbind(df_pop,temp)
  }
}

View(df_pop)
str(df_pop)

## 필요한 열 선택 및 열이름 변환
population<-select(df_pop,STDR_DE_ID, ADSTRD_CODE_SE, TOT_LVPOP_CO)
population<-rename(population, 기준일ID=STDR_DE_ID, 행정동코드=ADSTRD_CODE_SE, 총생활인구수=TOT_LVPOP_CO)
View(population)
str(population)

## 법정동코드 변수 추가
population$id <- 0
population$id <- substr(population$행정동코드,1,5)

## id 숫자형으로 변환
population$id<-as.numeric(population$id)
View(population)

##결측치 행 찾기
dim(population)
sum(is.na(population))
population[!complete.cases(population), ]
SeoulWifi<-na.omit(population)
sum(is.na(population)) #결측치 제거된 것 확인
dim(is.na(population))


## csv파일로 저장
write.csv(population, file="Seoulpopulation.csv")
