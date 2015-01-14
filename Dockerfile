# drone ruby base
FROM  ubuntu:12.04
MAINTAINER Petr Michalec <epcim@apealive.net>

RUN apt-get update
RUN apt-get install curl sudo git mercurial subversion -y

RUN apt-get install -y linux-image-generic-lts-raring linux-headers-generic-lts-raring
RUN curl -sSL https://get.docker.com/ubuntu/ | sudo sh

RUN curl -L https://www.opscode.com/chef/install.sh | sudo bash -s -- -P chefdk
RUN locale-gen en_US.UTF-8

## from rosstimson/dind-docker-chefdk
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /opt/chefdk/bin:/.chefdk/gem/ruby/2.1.0/bin:/opt/chefdk/embedded/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Make Chef DK the primary Ruby/Chef development environment.
RUN echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
RUN chef gem install kitchen-docker
#RUN chef gem install kitchen-vcenter

#workaround (drone.io has no way yet to modify this image before git clone happens)
RUN git config --global http.sslverify false


VOLUME /var/lib/docker
CMD ["wrapdocker"]


