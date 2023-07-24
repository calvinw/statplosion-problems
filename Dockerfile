FROM rstudio/plumber

RUN apt-get update -qq && apt-get install -y --no-install-recommends pandoc

RUN R -e "install.packages('rmarkdown');"
RUN R -e "install.packages('devtools');"
RUN R -e "devtools::install_gitlab('mathplosion/statplosion');"

COPY . .

EXPOSE 8080

CMD [ "Rscript", "server.R"]
