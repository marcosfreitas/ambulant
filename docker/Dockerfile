FROM ubuntu:18.04
LABEL version="1.0.0" maintainer="marcosfreitas@c4network.com.br"

EXPOSE 80
EXPOSE 443

# @info This condition will persists after the build,
# maybe we should use ARGS instead or define it on shell script
ENV DEBIAN_FRONTEND noninteractive

# @info Fix locale error when running container
RUN apt-get update
RUN apt-get install -y locales locales-all sudo gnupg2

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /var/www/html

CMD /bin/bash