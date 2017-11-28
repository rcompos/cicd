FROM jenkins:2.60.3
MAINTAINER Ron Compos <C-Ronald.Compos@charter.com>

USER root

ADD basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

USER ${user}

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
