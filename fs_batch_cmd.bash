#!/usr/bin/env bash

#SBATCH -N 1
#SBATCH -p RM
#SBATCH --ntasks-per-node 1
#SBATCH -t 24:00:00

#
# expects SUBJ variable to exist 
#

source $SCRATCH/FS_setup.bash # setup FS

[ -z "$SUBJ" ] && echo "bad input SUBJ '$SUBJ' " && exit 1
inputfile=$(ls $SCRATCH/T1/sub-$SUBJ/*/anat/sub-${SUBJ}_T1w.nii.gz)
[ ! -r "$inputfile" ] && echo "bad input for $SUBJ: $inputfile DNE" && exit 1

if [ -d $SUBJECTS_DIR/$SUBJ ]; then
     echo "$SUBJ: have $SUBJECTS_DIR/$SUBJ "
     echo "WARNING: i dont know if this works!!!"
     echo "         remove $SUBJECTS_DIR/$SUBJ to restart instead"
     recon-all  -all -s $SUBJ -no-isrunning -make autorecon3
else
     recon-all  -all -s $SUBJ -i  $inputfile
fi
