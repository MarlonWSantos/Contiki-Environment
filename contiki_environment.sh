#!/usr/bin/env bash 
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
path_on_file(){
  file_path=$(grep -o /.*contiki $path_ListEvents)
}

 #Busca o path do diretório local
find_local_path(){
  local_path=$(pwd)
}

 #Compara o path local com o path do arquivo
compare_file_path_local_path(){
  if [ "$file_path" = "$local_path" ];then
    echo "Path são iguais"
  else
    echo "Path são diferente!"
    change_path
  fi
}

 #Muda o path do arquivo List Events pelo diretório atual
change_path(){
  echo "Alterando path no arquivo!"
  sed -i "s;$file_path;$local_path;g" $path_ListEvents
}

  #Instala os submódulos necessário para rodar o contiki pela primeira vez
install_submodules(){
  echo "Update Submódulos"
  git submodule update --init
}

 #Verifica se existe pasta msp430
verify_msp430(){
  if [ -d msp430-gcc-4.7.3 ];then
    echo "Diretório msp430-gcc-4.7.3 já existe"
  else
    download_msp430
  fi
}

 #Baixa o msp430
download_msp430(){
  echo "Baixando msp430"
  git clone https://github.com/MarlonWSantos/msp430-gcc-4.7.3.git
}

 #Verifica se já existe o diretório compilers do msp430
verify_compilers(){
  if [ -d /opt/compilers/ ];then
    echo "Diretório compilers já existe"
    cd ..
  else
    save_msp430
    cd ..
  fi
}

 #Extrai o conteúdo do msp430
unzip_file(){
 cd msp430-gcc-4.7.3/

  if [ -d mspgcc-4.7.3 ];then
    verify_compilers
  else
    tar -xvjf mspgcc-4.7.3.tar.bz2
    verify_compilers
  fi
}

 #Armazena os arquivos
save_msp430(){
 echo "Criando /opt/compilers"
 sudo mkdir /opt/compilers/
 sudo cp -R mspgcc-4.7.3/ /opt/compilers/
}

 #Compila o tunslip6.c e gera o binário
compile_tunslip6(){
  cd tools/

  if [ -e tunslip6 ];then
    echo "Binário tunslip6 já existe!"
    cd ..
  else
    echo "Compilando tunslip6"
    make tunslip6
    cd ..
  fi
}

 #Adiciona atalhos ao bashrc
create_alias(){
  echo "Verificando alias no bashrc"
  local export_compilers=$(grep "compilers/mspgcc-4.7.3/bin/" ~/.bashrc | wc -l)
  local alias_cooja=$(grep "alias cooja" ~/.bashrc | wc -l)
  local alias_tunslip6=$(grep "alias tunslip6" ~/.bashrc | wc -l)

  if [ $export_compilers -eq 0 ];then
     echo "Adicionando atalho para mspgcc-4.7.3"
     echo "export PATH=$PATH:/opt/compilers/mspgcc-4.7.3/bin/" >> ~/.bashrc
  fi


  if [ $alias_cooja -eq 0 ];then
     echo "Adicionando atalho para cooja"
     echo "alias cooja='cd `pwd`/tools/cooja && ant run'" >> ~/.bashrc
  fi


  if [ $alias_tunslip6 -eq 0 ];then
     echo "Adicionando atalho para tunslip6"
     echo "alias tunslip6='cd `pwd`/tools && sudo ./tunslip6 -a 127.0.0.1 aaaa::1/64'" >> ~/.bashrc
  fi

  source ~/.bashrc

}

 #Instalando dependências
install_dependences(){
  echo "Verificando dependências"
  local installed_ant=$(dpkg -l ant | wc -l)
  local installed_openjdk=$(dpkg -l openjdk-8-jdk | wc -l)
  
  if [ $installed_ant -eq 0 ];then
     sudo apt install ant
  else
     echo "ant já está instalado"
  fi

  if [ $installed_openjdk -eq 0 ];then
     sudo apt install openjdk-8-jdk
  else
     echo "openjdk-8-jdk já está instalado"
  fi
}

  #Chamadas para as funções
path_on_file
find_local_path
compare_file_path_local_path
install_submodules
verify_msp430
unzip_file
compile_tunslip6
create_alias
install_dependences


