#!/bin/bash

main() {
  ###########################################################################################################

  # 대상 id 정보
  local target_id=1
  readonly target_id

  # hostname 정보
  local hostname="localhost"
  readonly hostname

  # port 정보
  local port="9092"
  readonly port

  # zookeeper.connect 설정 (zookeeper 서버가 여러개일 경우 ,(쉼표)로 구분하여 입력)
  local zookeeper_connect="localhost:2181"
  readonly zookeeper_connect

  # 어느 폴더에 다운로드 받을 것인지
  local install_path="/downloads"
  readonly install_path

  # 다운로드 받을 대상에 대한 정보
  local target_name="kafka_2.13-3.0.1"
  readonly target_name

  local target_link="https://archive.apache.org/dist/kafka/3.0.1/kafka_2.13-3.0.1.tgz"
  readonly target_link

  local target_filename=${target_name}".tgz"
  readonly target_filename

  local target_folder=${install_path}"/"${target_name}
  readonly target_folder

  ###########################################################################################################

  mkdir $install_path

  pushd $install_path
  wget $target_link
  tar xvf $target_filename
  popd

  pushd $target_folder
  sed -i'' -r -e "/broker.id=0/c\broker.id=$target_id" ./config/server.properties
  sed -i'' -r -e "/\#listeners=PLAINTEXT\:\/\/\:$port/c\listeners=PLAINTEXT\:\/\/\:$port" ./config/server.properties
  sed -i'' -r -e "/\#advertised.listeners=PLAINTEXT\:\/\/your.host.name:$port/c\advertised.listeners=PLAINTEXT\:\/\/$hostname\:$port" ./config/server.properties
  sed -i'' -r -e "/zookeeper.connect=localhost\:2181/c\zookeeper.connect=$zookeeper_connect" ./config/server.properties
  popd

  # bin/kafka-server-start.sh config/server.properties
}

main
