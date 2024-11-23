# Exploring Districts in Seoul for Additional Public Wi-Fi Installation Based on Population Data <br/>
## 1. Project Goal
- Project introduction and goal
  - Goal: Identify districts in Seoul requiring additional public Wi-Fi installation based on the living population data of each district.
  - As part of the Digital New Deal policy, the Ministry of Science and ICT announced plans to expand free Wi-Fi in public places frequently used by citizens, with 10,000 new installations by the end of 2020. Starting in 2021, the plan includes extending installations to outdoor facilities to enhance convenience through free data access. Based on this initiative, this project explores areas in Seoul where additional public Wi-Fi installations are needed using public Wi-Fi service location data and living population data in Seoul.
    
## 2. Data
Data provided by the Seoul Metropolitan Government:
- Seoul Public Wi-Fi Service Location Information: http://data.seoul.go.kr/dataList/OA-20883/S/1/datasetView.do
  - Fields used: District, Year of Installation, X-coordinate, Y-coordinate
- Living Population in Seoul by Administrative Dong (Residents Only): http://data.seoul.go.kr/dataList/OA-14991/S/1/datasetView.do
  - Fields used: Reference Date ID, Administrative Dong Code, Total Living Population
- (Reference Data) Living Population in Seoul by Districts: https://data.seoul.go.kr/dataList/OA-15439/S/1/datasetView.do
  - Fields used: District-level data for 2019, 2020, and 2021
  - SeoulPopulation19-21.R: Process for extracting data for 2019–2021
  - wifi_pop.rda: Data storage for 2019–2021
    
## 3. Project Description
- Step 1: Scraping Public Data Portal API
  - Seoul Public Wi-Fi Service Location Information:
    - SeoulWifi_Scrapping.R: Script for scraping Seoul Public Wi-Fi service location data
    - SeoulWifi.csv: Scraped and saved data
  - Living Population by Administrative Dong (Residents Only):
    - Seoulpopulation_Scrapping.R: Script for scraping living population data by administrative dong
    - Seoulpopulation.csv: Scraped and saved data
    - pop_rank5.csv: Data for the top 5 districts based on living population

- Step 2: Exploratory Data Analysis (EDA)
  - Seoul Public Wi-Fi Service Location Information:
    - SeoulWifi_EDA.R: EDA process for public Wi-Fi location data
  - Living Population by Administrative Dong (Residents Only):
    - Seoulpopulation_EDA.R: EDA process for living population data

- Step 3: Dashboard Creation
  - Files required for dashboard loading:
    - Wifi_map_merge.rda, gu_count.rda, gu_name.csv
  - Files required for executing the dashboard package:
      - TL_SCCO_SIG.shp, TL_SCCO_SIG.prj, TL_SCCO_SIG.dbf, TL_SCCO_SIG.shx
  - Dashboard Visualizations(Dashboard.R)
    1. Map showing public Wi-Fi installations by district in Seoul</br>
    <img src="https://user-images.githubusercontent.com/75953480/144628706-f7e3bea1-2baa-41c1-bfd0-edb213c158c8.png" width="400" height="250"/></br>
    2. Bar graphs showing the number of public Wi-Fi installations by district over the years (2019, 2020, 2021)</br>
    <img src="https://user-images.githubusercontent.com/75953480/144721926-4444a5d5-71a8-4f58-b1c1-c86f192c130e.jpeg" width="600" height="150"/></br>
    <img src="https://user-images.githubusercontent.com/75953480/144721942-6123379c-3ae3-44f9-8075-e1063e86b4d6.jpeg" width="600" height="150"/></br>
    <img src="https://user-images.githubusercontent.com/75953480/144721945-52e14cec-4ffd-428a-980a-a4742f5bf1d9.jpeg" width="600" height="150"/></br>
    3. Word cloud displaying the total living population by district</br>
    <img src="https://user-images.githubusercontent.com/75953480/144702545-54d28f90-1f60-400c-ae91-8c87f7d17462.png" width="250" height="250"/></br>
    4. Treemap representing the total living population by district</br>
    <img src="https://user-images.githubusercontent.com/75953480/144702532-1638f9d3-736c-4105-b686-c2ca25b74af1.jpeg" width="550" height="250"/></br>
    5. Bar graphs showing the total living population by district over the years (2019, 2020, 2021)</br>
    <img src="https://user-images.githubusercontent.com/75953480/144723092-95165157-a410-43dd-a5c5-0f9d8dcc73b6.jpeg" width="600" height="250"/></br>
    <img src="https://user-images.githubusercontent.com/75953480/144723095-e21fb68b-9c94-4fc6-87dd-39d2cb099d30.jpeg" width="600" height="250"/></br>
    <img src="https://user-images.githubusercontent.com/75953480/144723097-21b1712b-06a2-4e2c-b646-65aee1bee947.jpeg" width="600" height="250"/></br>
    6. Bar graph illustrating the ratio of public Wi-Fi installations to living population by district</br>
    <img src="https://user-images.githubusercontent.com/75953480/144721693-b7e99609-4573-40be-b484-f6ee17d366c8.jpeg" width="550" height="250"/></br>
    7. Living population by district for November 2021</br>
    <img src="https://user-images.githubusercontent.com/75953480/144724546-88fb3ef8-6cb3-45cf-81df-8f3dc0b57964.jpeg" width="600" height="150"/></br>
    8. Line graph showing public Wi-Fi installation trends over the years</br>
    <img src="https://user-images.githubusercontent.com/75953480/144741793-abe2a213-ebf2-4b72-a7c0-a96ea8cca53b.jpeg" width="600" height="250"/></br>
  
## 4. Conclusion
- Based on the graph comparing the number of public Wi-Fi installations to living population, the top 6 districts are Jung-gu, Seongdong-gu, Gangseo-gu, Guro-gu, Eunpyeong-gu, and Dobong-gu. According to the article (https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=120seoulcall&logNo=221997117753), these districts align with planned installation areas, indicating that living population data influences the selection of public Wi-Fi installation sites.
- Installing public Wi-Fi in the top 6 districts could help bridge the disparity between Gangnam and Gangbuk areas.
- Additional analysis of November 2021 living population data suggests that the top 6 districts for further Wi-Fi installations are Gangnam-gu, Songpa-gu, Seocho-gu, Gangdong-gu, Nowon-gu, and Yeongdeungpo-gu.
  
## 5. Challenges and Future Work
- Updated Data: Incorporating the latest public data would enable more accurate analysis.
- 2021 Data Limitation: Public Wi-Fi installation data for 2021 appears significantly lower than 2020. It is unclear if this is due to incomplete data for 2021 or a halt in installations, creating challenges in interpretation.
- Data Size Issues: Due to the large size of the living population dataset, analysis was limited to a shortened timeframe. Extending the analysis period could yield better results.
- Influence of Non-Population Factors: While Jung-gu ranks first for public Wi-Fi installation priority, it is among the lower-ranked districts by total living population. This suggests that factors like public facilities and tourist attractions in the district (e.g., Seoul Plaza, City Hall) may have had a greater influence. Including additional datasets on public facilities and tourist attractions could provide more meaningful insights in future analyses.
  
## 6. Development Environment
- R Studio
- R Shiny
  
## 7. Notes
- 2019년wifi(누적x).jpeg, 2020년wifi(누적x).jpeg, 2021년wifi(누적x).jpeg: Bar graphs showing the number of public Wi-Fi installations per year.
- 2019년wifi누적.jpeg, 2020년wifi누적.jpeg, 2021wifi누적.jpeg: Bar graphs showing cumulative Wi-Fi installations up to 2019, 2020, and 2021, respectively.
- 2019년서울생활인구.JPG, 2020년서울생활인구.JPG, 2021년서울생활인구.JPG: Bar graphs showing total living population by district over the years.
- circlegraph_pop5.png: Pie chart showing the top 5 districts by living population.
- gu_population(크기순).jpeg: Bar graph showing living population by district (November 2021) in descending order.
- gu_wifi(크기순).jpeg: Bar graph showing cumulative public Wi-Fi installations by district up to 2021 (same as 2021년wifi누적.jpeg).
- 년도별wifi설치.jpeg: Line graph showing yearly public Wi-Fi installations.
