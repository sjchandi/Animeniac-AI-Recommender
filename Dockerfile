FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . /srv/shiny-server/

WORKDIR /srv/shiny-server/

RUN R -e "install.packages(c('shiny','shinyjs','DBI','RPostgres','glue','DT','reactable','httr2'))"

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=3838)"]
