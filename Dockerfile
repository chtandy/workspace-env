FROM ubuntu:22.04
MAINTAINER cht.andy@gmail.com
ARG DEBIAN_FRONTEND=noninteractive 
ENV TZ=Asia/Taipei

## 變更預設的dash 為bash
RUN set -eux \
  && echo "######### dash > bash ##########" \
  && mv /bin/sh /bin/sh.old && ln -s /bin/bash /bin/sh

## 安裝locales 與預設語系
RUN set -eux \
  && echo "######### apt install locales ##########" \
  && apt-get update && apt-get install --assume-yes locales bash-completion \
  && rm -rf /var/lib/apt/lists/* && apt-get clean \
  && locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 

# 安裝 vim 並設置 /etc/vim/vimrc
RUN set -eux \
  && echo "######### apt install vim ##########" \
  && apt-get update && apt-get install vim -y \
  && rm -rf /var/lib/apt/lists/* && apt-get clean \
  && { \
     echo "set paste"; \
     echo "syntax on"; \ 
     echo "colorscheme torte"; \
     echo "set t_Co=256"; \
     echo "set nohlsearch"; \
     echo "set fileencodings=ucs-bom,utf-8,big5,gb18030,euc-jp,euc-kr,latin1"; \
     echo "set fileencoding=utf-8"; \
     echo "set encoding=utf-8"; \
     } >> /etc/vim/vimrc

## 安裝sshd
RUN set -eux \
  && echo "######### apt install sshd ##########" \
  && apt-get update && apt-get install --assume-yes openssh-client openssh-server \
  && rm -rf /var/lib/apt/lists/* && apt-get clean \
  && sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config \
  && { \
     echo "    StrictHostKeyChecking no"; \
     echo "    UserKnownHostsFile /dev/null"; \
     } >> /etc/ssh/ssh_config \
  && mkdir /run/sshd

## 安裝工作會用到的套件, sshpass 為ansible 使用ssh passwd 需要的套件
RUN set -eux \
  && echo "######### install tools ##########" \
  && apt-get update \
  && apt-get install --assume-yes git iputils-ping dnsutils netcat jq curl wget bash-completion sudo  \
  && rm -rf /var/lib/apt/lists/* && apt-get clean

ADD entrypoint /
RUN chmod +x /entrypoint

ENTRYPOINT ["/entrypoint"]
