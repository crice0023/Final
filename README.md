# HW-Final Modern Workflow in Data Science
### Chris Rice
## EVS Data Shiny Product

# File Structure #
The structure is simple. All files are included in the Final_Shiny folder. However, the README is housed outside of that file. 

# Project Overview #

We used a clean data set from HW-2 and created a Shiny App that included an Overview, Exploration, Regression, Sex/Edu control buttons, Poly Age scroll bar, and a Download Report button. This application allows users to explore and analyze attitudes towards gender roles and immigrants using EVS data. Navigate through the tabs to explore different aspects of the data. There is a drop down with Overall countries and specific countries by name. 


# Issues Unresolved # ☹️

Much to my chagrin I was unable to get any data to change with the sex/edu control buttons. I spent at least 40 hours trying and it was very frustrating. This would have been a great thing to have help with in my opinion. However, maybe it does work and there are so few changes in the data, or poor data connectivity causing the problems. 

Age Polynomial Degree slide works wonderfully with the regression table and residual vs fitted plot. For the 'sex' and 'edu' toggle buttons, when selected, they flash as if to work but I do not observe data changes in the regression table or residual vs fitted plot. 

The download report button does not work from the shiny web application. 


# Link to Shiny App # 👍
we established a connection to shinyapps.io and confirmed any interested parties could effectively see the output we created. Unfortunately, there was an initial issue that would not allow users to view the output. Specifically, we learned that we needed to add the df1 (dataframe) reference to our shiny app.R code. Once that was in place the problem was resolved. Here is a link to the shiny app [Shiny App Link](https://crice0023.shinyapps.io/Final_Shiny/)

:accessibility: This project was very tough and advanced. I did not create the perfect project by any means. Please grade accordingly. 

## Session Info

```
locale:
[1] LC_COLLATE=English_United States.utf8 
[2] LC_CTYPE=English_United States.utf8   
[3] LC_MONETARY=English_United States.utf8
[4] LC_NUMERIC=C                          
[5] LC_TIME=English_United States.utf8    

time zone: America/New_York
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets 
[6] methods   base     

other attached packages:
 [1] DT_0.33         haven_2.5.4     lubridate_1.9.3
 [4] forcats_1.0.0   stringr_1.5.1   purrr_1.0.2    
 [7] readr_2.1.5     tidyr_1.3.1     tibble_3.2.1   
[10] tidyverse_2.0.0 ggplot2_3.5.1   dplyr_1.1.4    

loaded via a namespace (and not attached):
 [1] gtable_0.3.5      compiler_4.3.0   
 [3] tidyselect_1.2.1  scales_1.3.0     
 [5] yaml_2.3.8        fastmap_1.1.1    
 [7] R6_2.5.1          labeling_0.4.3   
 [9] generics_0.1.3    knitr_1.46       
[11] htmlwidgets_1.6.4 munsell_0.5.1    
[13] pillar_1.9.0      tzdb_0.4.0       
[15] rlang_1.1.3       utf8_1.2.4       
[17] stringi_1.8.3     xfun_0.43        
[19] timechange_0.3.0  cli_3.6.2        
[21] withr_3.0.0       magrittr_2.0.3   
[23] digest_0.6.34     grid_4.3.0       
[25] rstudioapi_0.16.0 hms_1.1.3        
[27] lifecycle_1.0.4   vctrs_0.6.5      
[29] evaluate_0.23     glue_1.7.0       
[31] farver_2.1.1      rsconnect_1.2.2  
[33] fansi_1.0.6       colorspace_2.1-0 
[35] rmarkdown_2.26    tools_4.3.0      
[37] pkgconfig_2.0.3   htmltools_0.5.8.1

```
