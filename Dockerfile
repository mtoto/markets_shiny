FROM rocker/shiny
MAINTAINER Tamas Szilagyi (tszilagyi@outlook.com)

## install R package dependencies
RUN apt-get update && apt-get install -y gnupg2 \
    libxml2-dev \
    libssl-dev \
    ## clean up
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/ \ 
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
    
## Install packages from CRAN
RUN install2.r --error \ 
    -r 'http://cran.rstudio.com' \
    dplyr \
    tidyr \ 
    fuzzyjoin \
    stringr \
    ggthemes \
    quantmod \ 
    ggplot2 \
    shinydashboard \
    shinythemes \ 
    ## clean up
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Install packages from github
RUN Rscript -e "devtools::install_github('rstudio/shinytest', 'rstudio/webdriver')"

## Install phantomjs
RUN Rscript -e "webdriver::install_phantomjs()"

## Assume shiny app is in build folder /app2
COPY ./app2 /srv/shiny-server/myapp/


