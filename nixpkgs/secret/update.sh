#!/usr/bin/env sh
perl -0777 -pi -e '$tree=`exa -I XX* --tree --group-directories-first`; s/<!-- tree-output -->\n```\n(?:.|\n)+```/<!-- tree-output -->\n```\n$tree```/' README.md
