FROM ubuntu:20.04

MAINTAINER supranovich2@gmail.com

RUN apt-get update \
&& apt install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev git curl libgdbm-dev \
&& git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
&& echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
&& . ~/.bashrc \
&& echo 'eval "$(rbenv init -)"' >> ~/.bashrc \
&& git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
&& rbenv install 2.7.2 \
&& rbenv global 2.7.2




