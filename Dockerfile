# drone ruby base
FROM  ubuntu
MAINTAINER Jesse Nelson <spheromak@gmail.com>

RUN apt-get update
RUN apt-get install curl -y

RUN curl -L https://www.opscode.com/chef/install.sh | sudo bash -s -- -P chefdk
RUN locale-gen en_US.UTF-8

## from rosstimson/dind-docker-chefdk
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /opt/chefdk/bin:/.chefdk/gem/ruby/2.1.0/bin:/opt/chefdk/embedded/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Make Chef DK the primary Ruby/Chef development environment.
RUN echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
RUN chef gem install kitchen-docker
VOLUME /var/lib/docker
CMD ["wrapdocker"]


