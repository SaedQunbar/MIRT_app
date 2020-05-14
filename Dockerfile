# https://juanitorduz.github.io/dockerize-a-shinyapp/
# https://www.bjoern-bos.de/post/learn-how-to-dockerize-a-shinyapp-in-7-steps/
# get shiny serves plus tidyverse packages image
FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev 

# Download and install library
RUN R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinydashboard', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('plotly', repos='http://cran.rstudio.com/')"

# copy the app to the image
COPY MIRT_app.Rproj /srv/shiny-server/
COPY app.R /srv/shiny-server/

# Copy configuration files into the Docker image
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh

# make all app files readable (solves issue when dev in Windows, but building in Ubuntu)
# allow permissions
RUN sudo chown -R shiny:shiny /srv/shiny-server
RUN chmod -R 755 /srv/shiny-server/
RUN chmod -R 755 /usr/bin/shiny-server.sh
RUN chmod -R 755 /etc/shiny-server/shiny-server.conf

# listen on this port, needs to match shiny-server.conf
EXPOSE 3838


CMD ["/usr/bin/shiny-server.sh"]
#CMD ["/usr/bin/shiny-server"]
#CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/app.R')"]