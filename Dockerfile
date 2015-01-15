FROM rosstimson/dind-chefdk
MAINTAINER Petr Michalec <epcim@apealive.net>

# workaround (drone.io has no way yet to modify this image before git clone happens)
RUN git config --global http.sslverify false

VOLUME /var/lib/docker
CMD ["wrapdocker"]


