FROM docker.io/library/debian:bookworm

ENV \
  DEBIAN_FRONTEND="noninteractive" \
  DEBCONF_NOWARNINGS="yes"

# Configure APT
RUN sed -i 's/^Components: main$/Components: main contrib non-free non-free-firmware/g' /etc/apt/sources.list.d/debian.sources \
  && dpkg --add-architecture i386 \
  && apt-get -y update \
  && apt-get -y upgrade

# Locales & tzdata
RUN TZ=Etc/UTC apt-get -y install tzdata \
  && apt-get -y install locales \
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && locale-gen en_US.UTF-8 UTF-8 && update-locale en_US.UTF-8 UTF-8 \
  && echo "LANG=en_US.utf-8" >> /etc/environment \
  && echo "LC_ALL=en_US.utf-8" >> /etc/environment

# Packages
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
  && echo steam steam/license note '' | debconf-set-selections \
  && apt-get -y install expect curl steamcmd jq \
  && curl -L -o /usr/local/bin/vdftool https://github.com/notpeelz/vdftool/releases/download/v0.1.0/vdftool-x86_64-unknown-linux-gnu \
  && chmod +x /usr/local/bin/vdftool \
  && ln -sT vdftool /usr/local/bin/vdf2json \
  && ln -sT vdftool /usr/local/bin/json2vdf

COPY ./bin /app/bin

ENTRYPOINT ["/app/bin/get-steam-app-info.sh"]
