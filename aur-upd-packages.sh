#!/bin/bash
links_number=0
#Создаем файлы
touch packages.txt
touch packages_clear.txt
#Очищаем если уже существуют
echo -n > packages.txt
echo -n > packages_clear.txt
all_packages=$(curl -s https://aur.archlinux.org/packages\?O\=250\&SeB\=nd\&K\=\&outdated\=\&SB\=p\&SO\=d\&PP\=250\&submit\=Go | grep " packages found." | sed '1d'| sed -e 's/[^0-9]//g')
echo 'Всего пакетов' $all_packages
all_pages=$(curl -s curl -s https://aur.archlinux.org/packages\?O\=250\&SeB\=nd\&K\=\&outdated\=\&SB\=p\&SO\=d\&PP\=250\&submit\=Go | grep 'Page ' | sed '1d' | tr -d 'a-z' | tr -d 'A-Z' | tr -d ' ' | sed 's/.//' | sed -e 's/[^0-9]//g')
echo 'Всего страниц' $all_pages
#стартовая страницаcat
start_link="https://aur.archlinux.org/packages?O=0&SeB=nd&K=&outdated=&SB=p&SO=d&PP=250&submit=Go"
curl_link=$(curl -s $start_link | grep -E 'packages/[a-z A-z 0-9]' > packages.txt)
for (( count=0; count <= $all_pages; count++ ))
do
echo $count_pages
echo 'Парсим список пакетов...'
echo 'Всего страниц ' $count 'из' $all_pages
#Заменяем значения в ссылке
count_packages=$(( count_packages+=250 ))
echo $count_packages
one_link="https://aur.archlinux.org/packages?O="
two_link="&SeB=nd&K=&outdated=&SB=p&SO=d&PP=250&submit=Go"
link="${one_link}${count_packages}${two_link}!!!"
echo $link
#Сохраняем все /packages в файл
curl_link=$(curl -s $link | grep  'packages/[a-z A-z 0-9]' >> packages.txt)
$curl_link
cat packages.txt >> packages_clear.txt
echo -n > packages.txt
if [ $count == $all_packages ]
then
break
fi
done
echo "Пакеты синхронизированны"
cat packages_clear.txt | tr -d ' ' | sed 's/........//' | sed 's/.\{2\}$//' > packages.tmp
mv -f packages.tmp packages.txt
rm packages_clear.txt
#cat -n packages.txt
