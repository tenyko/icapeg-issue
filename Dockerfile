FROM rockylinux:8.9
WORKDIR /opt/icapeg
RUN dnf -y install golang git nginx squid vim-enhanced findutils procps iproute

RUN git clone https://github.com/egirna/icapeg.git .
RUN go build .

RUN cp /opt/icapeg/ICAPeg-DS.pdf /usr/share/nginx/html/
RUN cp /opt/icapeg/files-for-testing/sample.pdf /usr/share/nginx/html/

COPY config.toml squid.conf test.bash .
COPY static.conf /etc/nginx/conf.d/

CMD /bin/bash -x -e test.bash
