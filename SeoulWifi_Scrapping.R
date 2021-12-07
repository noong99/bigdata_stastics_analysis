library(XML)
library(RCurl)
library(dplyr)

# 1. 데이터 수집 - API 스크래핑 ####
# 무료 와이파이 현황(개방표준)####

url<-"http://openapi.seoul.go.kr:8088"
myKey<-"5064677356796f6f37334b6341556a"
StartIndex=1
EndIndex=1

myURL<-paste(url,"/",myKey,"/xml/TbPublicWifiInfo/",StartIndex,"/",EndIndex,sep="")
myURL

#13628개의 데이터 불러오기 위해 수열 지정
start<-seq(from=1, to=13628, by=1000)

df_wifi<-data.frame()
for (StartIndex in start) {
  EndIndex=StartIndex+999 #한번 요청할 때 1000을 넘지 못함
  myURL<-paste(url,"/",myKey,"/xml/TbPublicWifiInfo/",StartIndex,"/",EndIndex,sep="")
  myxml<-getURL(myURL)
  myxml<-xmlParse(myxml)
  xmlRoot(myxml)
  temp<-xmlToDataFrame(getNodeSet(myxml,'//row'))
  df_wifi<-rbind(df_wifi,temp)
}

str(df_wifi)

## 필요한 변수 선택
FreeWifi<-select(df_wifi,X_SWIFI_WRDOFC, X_SWIFI_CNSTC_YEAR, LAT, LNT)
## 열이름 변환
FreeWifi<-rename(FreeWifi, 자치구=X_SWIFI_WRDOFC, 설치년도=X_SWIFI_CNSTC_YEAR, 위도=LAT, 경도=LNT)
View(FreeWifi)
str(FreeWifi)

## 법정동코드 변수 id 추가
FreeWifi$id<-0
for (i in 1:13628) {
    FreeWifi[i,]$id<-switch(FreeWifi[i,]$자치구, "강남구"=11680, "강동구"=11740, "강북구"=11305, "강서구"=11500, "관악구"=11620, "광진구"=11215, "구로구"=11530, "금천구"=11545, "노원구"=11350, "도봉구"=11320, "동대문구"=11230, "동작구"=11590, "마포구"=11440, "서대문구"=11410, "서초구"=11650, "성동구"=11200, "성북구"=11290, "송파구"=11710, "양천구"=11470, "영등포구"=11560, "용산구"=11170, "은평구"=11380, "종로구"=11110, "중구"=11140, "중랑구"=11260)
}
## id 숫자형으로 변환
FreeWifi$id<-as.numeric(FreeWifi$id)
View(FreeWifi)

##결측치 행 찾기->데이터에 경기도에 해당되는 과천시가 포함되어있는 것으로 확인
dim(FreeWifi)
sum(is.na(FreeWifi))
FreeWifi[!complete.cases(FreeWifi), ]
SeoulWifi<-na.omit(FreeWifi)
sum(is.na(SeoulWifi)) #결측치 제거된 것 확인
dim(is.na(SeoulWifi))

## csv파일로 저장
write.csv(SeoulWifi, file="SeoulWifi.csv")
