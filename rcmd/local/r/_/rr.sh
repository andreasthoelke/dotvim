#!/bin/zsh

# rlist=$(< r/_/rlist)
rlist=({1..10})

ab='hii'

while read rel
do
  echo 'the value is: ' $rel
done <<<$rlist

# while read rel
# do
#   echo $rsour $rdest $ropt $rel | tee -a $me/out
# done <<<$rlist

# for rel in $rlist
# do
#   echo $ab $rel
# done


