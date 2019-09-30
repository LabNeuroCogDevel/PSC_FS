#!/usr/bin/env bash

#SBATCH -N 1
#SBATCH -p RM
#SBATCH --ntasks-per-node 1
#SBATCH -t 40:00:00

#
# expects SUBJ variable to exist 
#

source $SCRATCH/FS_setup.bash # setup FS

[ -z "$SUBJ" ] && echo "bad input SUBJ '$SUBJ' " && exit 1
! [[ $SUBJ =~ ([0-9]{5})_([0-9]{8}) ]] && echo "BADID $SUBJ" && continue
inputfile=$(ls $SCRATCH/T1/sub-${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/anat/sub-${BASH_REMATCH[1]}_T1w.nii.gz)
[ ! -r "$inputfile" ] && echo "bad input for $SUBJ: $inputfile DNE" && exit 1

if [ -d $SUBJECTS_DIR/$SUBJ ]; then
     echo "$SUBJ: have $SUBJECTS_DIR/$SUBJ "
     echo "WARNING: i dont know if this works!!!"
     echo "         remove $SUBJECTS_DIR/$SUBJ to restart instead"
     cmd="recon-all  -all -s $SUBJ -no-isrunning -make autorecon3"
else
     cmd="recon-all  -all -s $SUBJ -i  $inputfile"
fi
# only do it if not in DRYRUN mode
[ -n "$DRYRUN" ] && echo $cmd || eval $cmd
