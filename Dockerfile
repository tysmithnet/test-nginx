FROM ubuntu:xenial
RUN apt-get update
RUN apt-get install -y apt-transport-https curl lsb-core
RUN echo "deb https://kong.bintray.com/kong-deb `lsb_release -sc` main" | tee -a /etc/apt/sources.list
RUN curl -o bintray.key https://bintray.com/user/downloadSubjectPublicKey?username=bintray
RUN apt-key add bintray.key
RUN apt-get update
RUN apt-get install -y kong
RUN apt-get install -y vim less
COPY kong.conf /etc/kong/
COPY custom_nginx.template /etc/kong
COPY index.html /var/www/
COPY something.html /var/www/
RUN ln -s /usr/local/share/lua/5.1/kong/templates /tmpl
RUN ln -s /usr/local/kong/ /kong
CMD ["bash", "-c", "kong migrations bootstrap -c /etc/kong/kong.conf && kong start -c /etc/kong/kong.conf --nginx-conf /etc/kong/custom_nginx.template && tail -f /dev/null"]