#!/bin/bash 
#
#
#
#   Contiki Environment prepare the local environment to run contiki 
#   Copyright (C) 2019,2020 Marlon W. Santos <marlon.santos.santos@icen.ufpa.br>
#
#
#	
#   This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>


  #Caminho para o List Events dentro do contiki
path_ListEvents="./tools/cooja/java/org/contikios/cooja/dialogs/Events/ListEvents.java"

  #Busca o path dentro do arquivo ListEvents.java
function path_on_file(){
  file_path=`grep -o /.*contiki $path_ListEvents`
}

 #Busca o path do diretório local
function find_local_path(){
  local_path=`pwd`
}

 #Muda o path do arquivo List Events pelo diretório atual
function change_path(){
  sed -i "s;$file_path;$local_path;g" $path_ListEvents
}

  #Instala os submódulos necessário para rodar o contiki pela primeira vez
function install_submodules(){
  git submodule update --init
}


 #Baixa o mps430
function download_mps430(){
 git clone https://github.com/MarlonWSantos/msp430-gcc-4.7.3.git
}

 #Extrai o conteúdo do msp430
function unzip_file(){
 cd msp430-gcc-4.7.3/ &&
 tar -xvjf mspgcc-4.7.3.tar.bz2
}

 #Armazena os arquivos
function save_msp430(){
 sudo mkdir /opt/compilers/ &&
 sudo cp -R mspgcc-4.7.3/ /opt/compilers/
 cd ..
}

 #Compila o tunslip6.c e gera o binário
function compile_tunslip6(){
 cd tools/
 make tunslip6
 cd ..
}


 #Adiciona atalhos ao bashrc
function create_alias(){
 echo "export PATH=$PATH:/opt/compilers/mspgcc-4.7.3/bin/" >> ~/.bashrc &&
 echo "alias cooja='cd `pwd`/tools/cooja && ant run'" >> ~/.bashrc &&
 echo "alias tunslip6='cd `pwd`/tools && sudo ./tunslip6 -a 127.0.0.1 aaaa::1/64'" >> ~/.bashrc &&
 source ~/.bashrc
}

 #Instalando dependências
function install_dependences(){
 sudo apt install ant &&
 sudo apt install openjdk-8-jdk
}

  #Chamadas para as funções
path_on_file

find_local_path

change_path

install_submodules

download_mps430

unzip_file

save_msp430

compile_tunslip6

create_alias

install_dependences
