FROM ubuntu:xenial
RUN apt-get update
RUN apt-get install -y apt-transport-https curl lsb-core
RUN echo "deb https://kong.bintray.com/kong-deb `lsb_release -sc` main" | tee -a /etc/apt/sources.list
RUN curl -o bintray.key https://bintray.com/user/downloadSubjectPublicKey?username=bintray
RUN apt-key add bintray.key
RUN apt-get update
RUN apt-get install -y kong
COPY kong.conf /etc/kong/
COPY custom_nginx.template /etc/kong
COPY index.html /var/www/
CMD ["bash", "-c", "kong migrations bootstrap -c /etc/kong/kong.conf && kong start -c /etc/kong/kong.conf --nginx-conf /etc/kong/custom_nginx.template && tail -f /dev/null"]