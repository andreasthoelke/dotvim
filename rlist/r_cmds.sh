# this is for testing / debugging
echo $r_source $r_dest $r_el
# wget -O temp/gh.zip https://github.com/ghostdogpr/caliban/archive/series/2.x.zip
wget -O temp/gh.zip https://github.com/ghostdogpr/caliban/archive/series/2.x.zip
unzip -l $r_source $r_el -d $r_dest
echo "unzip -l $r_source $r_el -d $r_dest"
unzip -j $r_source $r_el -d $r_dest
mv $r_el $r_dest
cp $r_el $r_dest
touch $r_el
mkdir $r_el
# note this might need a -r(cursive) flag for folders?
del $r_el



