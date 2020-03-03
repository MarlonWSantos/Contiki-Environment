#!/bin/bash 
#
#
#
#   Contiki Environment prepare the local environment to run contiki 
#   Copyright (C) 2019 Marlon W. Santos <marlon.santos.santos@icen.ufpa.br>
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


  #Chamadas para as funções
path_on_file

find_local_path

change_path

install_submodules

