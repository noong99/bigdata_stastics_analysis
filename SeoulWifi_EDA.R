# 2. EDA 탐색과정 ####
# 서울시 공공와이파이 서비스 위치 정보 #### 

library(dplyr)

SeoulWifi.df<-read.csv("SeoulWifi.csv")
str(SeoulWifi.df)
head(SeoulWifi.df)
dim(SeoulWifi.df)
SeoulWifi.df$id<-as.numeric(SeoulWifi.df$id)
View(SeoulWifi.df)

## 년도 고려하여 자치구 상관없이 공공와이파이 설치현황 
gu_year <- SeoulWifi.df %>% 
  group_by(설치년도) %>% 
  summarise(누적설치수 = sum(n()))
View(gu_year)
ggplot(data = gu_year, aes(x = 설치년도, y = 누적설치수, ymax = 누적설치수 + 500)) + geom_line() + geom_point(size=3.5, colour = "darkgreen") +
  geom_text(mapping=aes(label = 누적설치수, fontface='bold'),vjust=-1.2) + labs(title = '년도에 따른 공공와이파이 설치 현황') + theme_minimal() +
  theme(plot.title=element_text(face="bold",hjust=0.5,size=15,color = "darkgreen")) + scale_color_brewer(palette= "BrBG")

## 년도 상관없이(전체누적) 자치구별 공공와이파이 설치현황
gu_count<-SeoulWifi.df%>%
  group_by(id)%>%
  summarise(n=n())

## 법정동코드에 해당하는 자치구 이름 추가
gu_count <- gu_count %>% mutate(name= case_when(
  id == 11680 ~"강남구",id == 11740 ~"강동구",id == 11305 ~"강북구",
  id == 11500 ~"강서구",id == 11620 ~"관악구",id == 11215 ~"광진구",
  id == 11530 ~"구로구",id == 11545 ~"금천구",id == 11350 ~"노원구",
  id == 11320 ~"도봉구",id == 11230 ~"동대문구",
  id == 11590 ~"동작구",id == 11440 ~"마포구",
  id == 11410 ~"서대문구",id == 11650 ~"서초구",
  id == 11200 ~"성동구",id ==11290 ~"성북구", id == 11710 ~"송파구",
  id == 11470 ~"양천구",id == 11560 ~"영등포구",
  id == 11170 ~"용산구",id == 11380 ~"은평구",id == 11110 ~"종로구",
  id == 11140 ~"중구", id == 11260 ~"중랑구", id == 11320 ~"도봉구"
))

# 년도별 자치구별 공공와이파이 설치현황
# 2019년 누적 
gu_2019 <- SeoulWifi.df %>% 
  filter(설치년도<=2019) %>% 
  group_by(자치구) %>% 
  summarise(n=n())
View(gu_2019)

## 2019년 누적 히스토그램
ggplot(data= gu_2019, aes(x = reorder(자치구,-n), y=n)) +geom_col() + labs(title="2019년 wifi 누적")

# 2019년만 히스토그램
gu_19only <- SeoulWifi.df %>% 
  filter(설치년도==2019) %>% 
  group_by(자치구) %>% 
  summarise(n=n())
View(gu_19only)
ggplot(data=gu_19only, aes(x = reorder(자치구,-n),y=n)) +geom_col() + labs(title="2019년 wifi")

# 2020년 누적
gu_2020 <- SeoulWifi.df %>% 
  filter(설치년도<=2020) %>% 
  group_by(자치구) %>% 
  summarise(n=n())
View(gu_2020)
## 2020년 누적 히스토그램
ggplot(data= gu_2020, aes(x = reorder(자치구,-n), y=n)) +geom_col() + labs(title="2020년 wifi 누적")

# 2020년만 히스토그램
gu_20only <- SeoulWifi.df %>% 
  filter(설치년도==2020) %>% 
  group_by(자치구) %>% 
  summarise(n=n())
View(gu_20only)

ggplot(data=gu_20only, aes(x = reorder(자치구,-n),y=n)) +geom_col() + labs(title="2020년 wifi")

# 2021년 누적
gu_2021 <- SeoulWifi.df %>% 
  filter(설치년도<=2021) %>% 
  group_by(자치구) %>% 
  summarise(n=n())
View(gu_2021)
## 2021년 누적 히스토그램
ggplot(data= gu_2021, aes(x = reorder(자치구,-n), y=n)) +geom_col() + labs(title="2021년 wifi 누적")

# 2021년만 히스토그램
gu_21only <- SeoulWifi.df %>% 
  filter(설치년도==2021) %>% 
  group_by(자치구) %>% 
  summarise(n=n())
View(gu_21only)
ggplot(data=gu_21only, aes(x = reorder(자치구,-n),y=n)) +geom_col() + labs(title="2021년 wifi")

## 지도 시각화
library(ggmap)
library(ggplot2)
library(raster)
library(rgeos)
library(maptools)
library(rgdal)

map <- shapefile("TL_SCCO_SIG.shp") ## TL_SCCO_SIG 파일들 모두 저장되어있어야함.
## map 좌표계 변환
map <- spTransform(map, CRSobj = CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))
## map을 데이터프레임으로 변환
new_map <- fortify(map, region = 'SIG_CD')
View(new_map)
new_map$id <- as.numeric(new_map$id)
## 서울 데이터 추출
seoul_map <- new_map[new_map$id <= 11740,]
View(seoul_map)
## 데이터 합치기
merge <- merge(seoul_map, gu_count, by='id')

save(merge, file="Wifi_map_merge.rda")
