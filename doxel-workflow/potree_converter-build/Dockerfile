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

COPY bin/PotreeConverter.container /usr/local/bin/PotreeConverter

USER $user

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
   -b develop \
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

COPY resources /home/$user/src/PotreeConverter/build/PotreeConverter/resources

WORKDIR /home/$user

CMD ["/bin/bash"]
