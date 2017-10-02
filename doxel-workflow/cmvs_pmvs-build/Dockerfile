FROM debian:stretch-slim

ARG user=doxel
ARG debian_mirror=deb.debian.org

# setup system and get build dependencies
RUN useradd --create-home --shell /bin/bash $user \
 && sed -r -i -e s/deb.debian.org/$debian_mirror/ /etc/apt/sources.list \
 && apt-get update && apt-get install -y \
      build-essential \
      cmake \
      git

USER $user
ENV PATH $PATH:/home/$user/local/bin/

# openMVG build options

# clone build and install
WORKDIR /home/$user
RUN git clone \
      --single-branch \
      -b master \
      --recursive \
       https://github.com/pmoulon/cmvs-pmvs \
       src/cmvs-pmvs \
 && cd src/cmvs-pmvs \
 && mkdir build \
 && cd build \
 && cmake \
      -DCMAKE_BUILD_TYPE=RELEASE \
      -DCMAKE_INSTALL_PREFIX="/home/$user/local" \
      ../program/ \
 && make -j $(nproc) \
 && make install

CMD ["/bin/bash", "-l"]
