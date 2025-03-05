#!/bin/sh

if [ -e labwc/ ]; then
	echo "warn: using existing labwc/"
else
	git clone https://github.com/labwc/labwc.git
fi

cd labwc

../count.sh $(head -n 1 ../data.txt | awk '{ print $1 }') >> tmp.txt

cat ../data.txt >> tmp.txt
mv tmp.txt ../data.txt

cd ..

./plot.sh

imv graph.png
