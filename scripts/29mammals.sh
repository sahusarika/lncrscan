#!/bin/sh

str1="s/hg19/Human/"
str2="s/panTro2/Chimp/"
str3="s/rheMac2/Rhesus/"
str4="s/tarSyr1/Tarsier/"
str5="s/micMur1/Mouse_lemur/"
str6="s/otoGar1/Bushbaby/"
str7="s/tupBel1/TreeShrew/"
str8="s/mm9/Mouse|/"
str9="s/rn4/Rat/"
str10="s/dipOrd1/Kangaroo_rat/"

str11="s/cavPor3/Guinea_Pig/"
str12="s/speTri1/Squirrel/"
str13="s/oryCun2/Rabbit/"
str14="s/ochPri2/Pika/"
str15="s/vicPac1/Alpaca/"
str16="s/turTru1/Dolphin/"
str17="s/bosTau4/Cow/"
str18="s/equCab2/Horse/"
str19="s/felCat3/Cat/"
str20="s/canFam2/Dog/"

str21="s/myoLuc1/Microbat/"
str22="s/pteVam1/Megabat/"
str23="s/eriEur1/Hedgehog/"
str24="s/sorAra1/Shrew/"
str25="s/loxAfr3/Elephant/"
str26="s/proCap1/Rock_hyrax/"
str27="s/echTel1/Tenrec/"
str28="s/dasNov2/Armadillo/"
str29="s/choHof1/Sloth/"

sed -e $str1 -e $str2 -e $str3 -e $str4 -e $str5 -e $str6 -e $str7 -e $str8 -e $str9 -e $str10 \
-e $str11 -e $str12 -e $str13 -e $str14 -e $str15 -e $str16 -e $str17 -e $str18 -e $str19 -e $str20 \
-e $str21 -e $str22 -e $str23 -e $str24 -e $str25 -e $str26 -e $str27 -e $str28 -e $str29 \
$1
