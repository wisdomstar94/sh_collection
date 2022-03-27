#!/bin/bash
####################################################################
# 재부팅을 해야 수정한 locale 반영됩니다.
####################################################################
apt-get install language-pack-ko -y
locale-gen ko_KR.UTF-8
update-locale LANG=ko_KR.UTF-8 LC_MESSAGES=POSIX

