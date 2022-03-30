FROM rocker/r-ver:4.0.5

MAINTAINER Emmanuel Blondel "eblondel.pro@gmail.com"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    git 

# install R core package dependencies
RUn install2.r --error --skipinstalled --ncpus -1 httpuv
RUN R -e "install.packages(c('remotes','jsonlite','yaml'), repos='https://cran.r-project.org/')"
# clone app
RUN git -C /root/ clone https://github.com/eblondel/dcf-shiny.git && echo "OK!"
RUN ln -s /root/dcf-shiny /srv/dcf-shiny
# install R app package dependencies
RUN R -e "source('./srv/dcf-shiny/install.R')"

#etc dirs (for config)
RUN mkdir -p /etc/dcf-shiny/

EXPOSE 3838

CMD ["R", "-e shiny::runApp('/srv/dcf-shiny',port=3838,host='0.0.0.0')"]
