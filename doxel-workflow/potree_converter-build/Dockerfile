FROM debian:stretch-slim

ARG user=doxel
ARG debian_mirror=deb.debian.org

# setup system and get build dependencies
RUN useradd --create-home --shell /bin/bash $user \
 && mkdir /home/$user/src \
 && chown $user:$user /home/$user/src \
 && sed -r -i -e s/deb.debian.org/$debian_mirror/ /etc/apt/sources.list \
 && apt-get update && apt-get install -y \
      build-essential \
      cmake \
      git

USER $user
ENV PATH $PATH:/home/$user/bin/

# openMVG build options

# clone build and install
WORKDIR /home/$user/src
RUN git clone \
   --single-branch \
   -b master \
   https://github.com/m-schuetz/LAStools.git \
 && cd LAStools/LASzip \
 && mkdir build \
 && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j $(nproc) \
 && cd /home/$user/src \
 && git clone \
   --single-branch \
   -b master \
   --recursive \
   https://github.com/potree/PotreeConverter.git \
 && cd PotreeConverter \
 && mkdir build \
 && cd build \
 && cmake \
   -DCMAKE_BUILD_TYPE=Release \
   -DLASZIP_INCLUDE_DIRS=/home/$user/src/LAStools/LASzip/dll \
   -DLASZIP_LIBRARY=/home/$user/src/LAStools/LASzip/build/src/liblaszip.so \
   .. \
 && make -j $(nproc)

CMD ["/bin/bash", "-l"]
