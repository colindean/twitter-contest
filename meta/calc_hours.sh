#!/bin/sh
i=0; for j in `awk '{print $2}' hours.txt`; do i=`echo $j + $i | bc`; done; echo $i
