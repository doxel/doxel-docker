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
 && useradd --create-home --shell /bin/bash $user
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
      gulp \
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
 && mkdir -p server/upload/tmp \
 && cd client \
 && npm install \
 && bower install \
 && cd viewer \
 && npm install \
 && bower install \
 && gulp wiredep \
 && cd .. \
 && lb-ng ../server/server.js app/scripts/lb-services.js \
 && grunt browserify wiredep compass --force
ADD data/upload.tar.gz /home/doxel/
ADD data/mongodb.tar.gz /
EXPOSE 3001
USER root
RUN cd /home/doxel/doxel-loopback/jpeg_metadata_size \
 && make PREFIX=/usr install
ADD data/postinstall.sh /tmp
ADD debug.sh /root/
ADD gitconfig /home/doxel/.gitconfig
RUN chmod +x /root/debug.sh \
 && chmod +x /tmp/postinstall.sh \
 && sync \
 && service mongodb start \
 && /tmp/postinstall.sh \
 && chown doxel:doxel /home/doxel -R
CMD service mongodb start \
 && su - doxel bash -l -c " \
         slc start doxel-loopback \
      && slc ctl set-size doxel-loopback \$(nproc) \
      && slc ctl log-dump doxel-loopback --follow \
    "
