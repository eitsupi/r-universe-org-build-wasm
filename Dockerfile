#FROM ghcr.io/r-wasm/webr:main
FROM ghcr.io/jeroen/webr:main

RUN apt-get update && apt-get install -y lsb-release && apt-get clean all

ENV R_LIBS_USER ""

# Setup Node, Emscripten & webR
ENV PATH /opt/emsdk:/opt/emsdk/upstream/emscripten:$PATH
ENV EMSDK /opt/emsdk
ENV WEBR_ROOT /opt/webr

# Set CRAN repo
COPY Renviron /etc/R/Renviron.site
COPY Rprofile /etc/R/Rprofile.site

# Install pak (and test load it)
#RUN /usr/bin/R \
#  -e 'install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch)); library(pak);'

RUN cp -Rf /root/R/x86_64-pc-linux-gnu-library/4.3/* /opt/R/4.3.0/lib/R/library/

# Install old Matrix that works on R-4.3.0
RUN R \
  -e 'install.packages(c("MASS", "Matrix"), repos = "https://p3m.dev/cran/__linux__/jammy/2023-08-14")'

# Copy webr-repo scripts
#COPY scripts /opt/webr-repo
RUN git clone https://github.com/r-wasm/webr-repo /opt/webr-repo

COPY entrypoint.sh /entrypoint.sh

# Build packages
ENTRYPOINT /entrypoint.sh
