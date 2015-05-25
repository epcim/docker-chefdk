# drone.io/dind image - as of now jpetazoo/dind uses ubuntu:14.04
## from rosstimson/dind-docker-chefdk
FROM jpetazzo/dind
MAINTAINER Petr Michalec <epcim@apealive.net>

RUN wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
RUN sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian trusty contrib" >> /etc/apt/sources.list.d/virtualbox.list'

RUN apt-get update
RUN apt-get install -qqy    curl \
                            sudo \
                            git \
                            mercurial \
                            subversion \
                            ca-certificates \
                            locales

RUN echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /opt/chefdk/bin:/.chefdk/gem/ruby/2.1.0/bin:/opt/chefdk/embedded/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


RUN curl -L https://www.opscode.com/chef/install.sh | sudo bash -s -- -P chefdk
# Make Chef DK the primary Ruby/Chef development environment.
RUN echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
RUN eval "$(chef shell-init bash)"


# VBOX  ########################################
# COPIED FROM https://registry.hub.docker.com/u/jencryzthers/vboxinsidedocker/dockerfile/

#FIXME
RUN sudo apt-cache search virtualbox
RUN sudo apt-get install virtualbox-dkms
RUN sudo apt-get install virtualbox-4.3

# DEBUG
RUN dpkg -s virtualbox-4.3
RUN virtualbox --version || echo FIXOK
# DEBUG
#
# Install Virtualbox Extension Pack
RUN VBOX_VERSION=`dpkg -s virtualbox-4.3 | grep '^Version: ' | sed -e 's/Version: \([0-9\.]*\)\-.*/\1/'` ; \
    wget http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack ; \
    sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack ; \
    rm Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack
# The virtualbox driver device must be mounted from host
#RUN sudo apt-get install -yq vagrant
RUN curl -L https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
RUN dpkg -i vagrant_1.7.2_x86_64.deb
# VBOX  ########################################

#RUN chef gem install kitchen-vagrant   #already in chefdk
RUN chef gem install kitchen-docker

# Install drivers to provision against vmware
#RUN chef gem install vagrant-vcenter
#RUN chef gem install vagrant-vcloud


## FIX UP'S

RUN chmod -R 0440 /etc/sudoers
RUN chmod -R 0440 /etc/sudoers.d

# workaround (drone.io has no way yet to modify this image before git clone happens)
RUN git config --global http.sslverify false

VOLUME /var/lib/docker
VOLUME /dev/vboxdrv

CMD ["wrapdocker"]


