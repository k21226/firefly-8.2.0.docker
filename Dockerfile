FROM       ubuntu:18.04 

RUN useradd ff -c 'Firefly user' -m -d /home/ff -s /bin/bash 
RUN mkdir -pv /apps/firefly820
RUN apt update && apt -y upgrade
RUN apt-get install -y apt-utils g++-4.8-multilib gcc-4.8-multilib gfortran-4.8-multilib gcc-multilib g++-multilib gfortran-multilib gcc g++ gfortran build-essential
USER ff 
COPY ff820.openmpi/* /apps/firefly820/ 
RUN mkdir -pv /home/ff/src 
COPY openmpi-2.0.1.tar.gz /home/ff/src
RUN cd /home/ff/src && tar xvzf openmpi-2.0.1.tar.gz 
RUN cd /home/ff/src/openmpi-2.0.1 && ./configure --prefix=/opt CFLAGS=-m32 CXXFLAGS=-m32 FFLAGS=-m32 FCFLAGS=-m32 && make -j20 
USER root
RUN cd /home/ff/src/openmpi-2.0.1 && make install 
RUN apt-get install -y openssh-server openssh-client openssh-sftp-server
USER ff 
ENV LD_LIBRARY_PATH /opt/lib
ENV FFHOME /apps/firefly820
ENV PATH /opt/bin:/apps/firefly820:$PATH
RUN mkdir /home/ff/samples
USER root
RUN mkdir /scratch
RUN apt-get install -y neovim
USER ff 
COPY ffrun.sh /home/ff/ffrun.sh
COPY samples.tgz /home/ff/samples/
RUN cd /home/ff/samples && tar xvfz samples.tgz
RUN mkdir /home/ff/work
