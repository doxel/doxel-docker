FROM debian:stretch
ARG user=doxel
ARG debian_mirror=deb.debian.org
RUN sed -r -i -e s/deb.debian.org/$debian_mirror/ /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y --force-yes \
      build-essential \
      bzip2 \
      ca-certificates \
      curl \
      git \
      wget \
      python \
      libexpat1-dev \
      ruby2.3 \
      ruby2.3-dev \
      vim \
      screen \
      net-tools \
      libssl-dev \
      mongodb \
 && gem install \
      compass \
      sass \
 && useradd --create-home --system --shell /bin/bash $user
USER $user
WORKDIR /home/$user
ARG nvm_version=v0.33.2
ARG node_version=v6.11.1
RUN wget -q -O /tmp/install.sh https://raw.githubusercontent.com/creationix/nvm/$nvm_version/install.sh \
 &&  . /tmp/install.sh \
 && export NVM_DIR="/home/$user/.nvm" \
 && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" \
 && nvm install $node_version \
 && echo progress=false >> .npmrc \
 && npm install -g npm \
 && npm install -g \
      bower \
      grunt-cli \
      q \
      strongloop \
      mongo-express \
 && git clone --recursive https://github.com/doxel/doxel-loopback.git \
 && cd doxel-loopback \
 && npm install \
 && cd jpeg_metadata_size \
 && make \
 && find . -type f -executable -exec strip \{\} \; \
 && cd .. \
 && mkdir -p server/upload_dev/tmp \
 && cd client \
 && npm install \
 && bower install \
 && lb-ng ../server/server.js app/scripts/lb-services.js \
 && grunt wiredep compass --force
ADD data/mongodb.tar.gz /
ADD data/upload.tar.gz /home/doxel/
EXPOSE 3001
USER root
RUN cd /home/doxel/doxel-loopback/jpeg_metadata_size \
 && make PREFIX=/usr install
CMD service mongodb start \
 && su - doxel bash -l -c " \
         slc start doxel-loopback \
      && slc ctl set-size doxel-loopback 4 \
      && slc ctl log-dump doxel-loopback --follow \
    "
