FROM rocker/shiny
MAINTAINER Tamas Szilagyi (tszilagyi@outlook.com)
    
## Install packages from CRAN
RUN install2.r --error \ 
    -r 'http://cran.rstudio.com' \
    tidyquant\ 
    plotly \
    ## clean up
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## assume shiny app is in build folder /shiny
COPY ./app /srv/shiny-server/myapp/
