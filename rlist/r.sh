#!/bin/zsh
lc=$0:a:h
comp=$(dirname $lc)
lib=/Users/at/.config/nvim/rlist
r_source=
r_dest=
r_opt=
r_list=$(< $lc/r_list)
> $lc/out






# <<== line 16
while read r_el
do
  echo 'rlist element:' $r_el | tee -a $ld/out
done <<<$r_list









