#!//usr/bin/env bash

# list all queued jobs
echo "queue:"
 squeue -A $(id -gn) -o %T -h|sort |uniq -c |sed 's/^/  /'

# default to 7t. other option is cog
[ -z "$1" ] && study=7t || study="$1"


have=$(find  scratch/$study/T1/ -iname '*.nii.gz'|wc -l)
started=$(ls -d scratch/$study/FS/1*|wc -l)
finished=$(grep -l 'finished without error'  scratch/$study/FS/1*/scripts/recon-all.log|wc -l)
echo "of $have: $started started and $finished finished"
