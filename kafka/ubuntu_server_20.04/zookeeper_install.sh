#!/bin/bash
main() {
  ###########################################################################################################

  # 대상 id 정보
  local target_id=1
  readonly target_id

  # port 정보
  local port=2181
  readonly port

  # 어느 폴더에 다운로드 받을 것인지
  local install_path="/downloads"
  readonly install_path

  # zookeeper 서버 정보들
  local zookeeper_servers=("zookeeper1.host.com:2888:3888" "zookeeper2.host.com:2888:3888" "zookeeper3.host.com:2888:3888")
  readonly zookeeper_servers

  # 다운로드 받을 대상에 대한 정보
  local target_name="apache-zookeeper-3.8.0-bin"
  readonly target_name

  local target_link="https://archive.apache.org/dist/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz"
  readonly target_link

  local target_filename=${target_name}".tar.gz"
  readonly target_filename

  local target_folder=${install_path}"/"${target_name}
  readonly target_folder

  ###########################################################################################################

  useradd zookeeper -m
  usermod --shell /bin/bash zookeeper
  (echo "zookeeper"; echo "zookeeper") | passwd zookeeper
  usermod -aG sudo zookeeper

  mkdir $install_path
  mkdir /var/lib/zookeeper

  pushd $install_path
  wget $target_link
  tar xvf $target_filename
  popd

  chown -R zookeeper:zookeeper $target_folder
  pushd $target_folder
  # cp ./conf/zoo_sample.cfg ./conf/zoo.cfg # zoo_sample.cfg 파일을 zoo.cfg 파일로 복사
  echo -e "tickTime=2000\ndataDir=/var/lib/zookeeper\nclientPort=$port\nsyncLimit=5\ninitLimit=5" > ./conf/zoo.cfg
  # sed -i'' -r -e "/dataDir=\/tmp\/zookeeper/c\dataDir=\/var\/lib\/zookeeper" ./conf/zoo.cfg # dataDir 경로를 /var/lib/zookeeper 로 교체
  for ((i = 0; i < ${#zookeeper_servers[@]}; i++)) ; do
    local server_id=`expr $i + 1`
    echo -e "server.$server_id=${zookeeper_servers[$i]}" >> ./conf/zoo.cfg
  done
  # for i in "${zookeeper_servers[@]}"
  # do
  #   echo "server.1=$i" >> ./conf/zoo.cfg
  # done
  echo -e $target_id > /var/lib/zookeeper/myid
  chown -R zookeeper:zookeeper /var/lib/zookeeper
  bin/zkServer.sh start
  popd
}

main

