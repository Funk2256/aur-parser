#!/bin/bash
#Читаем файл с пакетами
touch links_packages.txt
echo -n > links_packages.txt
aur_one_link="https://aur.archlinux.org"
while IFS= read -r line
do
  echo "$line"
  aur_regex='http.*"'
  aur_regex_cgit='/cgit.*"'
  aur_link="${aur_one_link}${line}"
  aur_curl_count=$(curl -s $aur_link | grep -A2 '<div id="pkgfiles" class="listing">' | sed '3d' | sed '1d' | tr -d ' ' | sed 's/............//' | sed 's/.\{6\}$//')
  aur_sources_link_curl=$(curl -s $aur_link | grep -A50 '<div id="pkgfiles" class="listing">' | grep '<a href' | sed '/dcelasun/d' | tr -d ' ' | grep -Eo $aur_regex | tr -d '"')
#  aur_sources_link_curl=$(curl -s $aur_link | grep -A50 '<div id="pkgfiles" class="listing">' | grep '<a href' | sed '/dcelasun/d' | tr -d ' ' | grep -Eo $aur_regex_cgit | tr -d '"')
#  aur_sources_link_curl=$(curl -s $aur_link | grep -A50 '<div id="pkgfiles" class="listing">' | grep '<a href' | sed '/dcelasun/d' | tr -d ' ' | grep -Eo 'http.*"' | tr -d '"')
  echo "Исходников в пакете ${aur_curl_count}"
  echo $aur_sources_link_curl
  echo $aur_sources_link_curl >> links_packages.txt

#  if echo $aur_curl_link =~ *'<a href="https://github.com/*'*; then
#    echo "Github"
#    echo $aur_curl_link >> links_packages.txt
#  elif
#   echo $aur_curl_link =~ *'<a href="https://gitlab.com'*; then 
#    echo "Gitlab"
#    echo $aur_curl_link >> links_packages.txt
#  else
#    echo "Ссылки не получены"
#    echo "None" >> links_packages.txt
#  fi
#  if [[ "$aur_curl_link" =~ *"github.com"*]]; then
#  aur_curl_link=$(curl -s $aur_link | grep '<a href="https://github.com/*' | sed '1d' || curl -s $aur_link | grep '<a href="https://gitlab.com*' | sed '1d')
#    echo $aur_curl_link
#    echo $aur_curl_link >> links_packages.txt
#  fi
done < packages.txt
