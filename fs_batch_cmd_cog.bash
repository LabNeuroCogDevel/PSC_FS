#!/usr/bin/env bash

#SBATCH -N 1
#SBATCH -p RM
#SBATCH --ntasks-per-node 1
#SBATCH -t 30:00:00

#
# expects SUBJ variable to exist 
#

export FREESURFER_HOME="$SCRATCH/freesurfer/"
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export SUBJECTS_DIR=$SCRATCH/cog/FS

[ -z "$SUBJ" ] && echo "bad input SUBJ '$SUBJ' " && exit 1
inputfile=$SCRATCH/cog/T1/$SUBJ.nii.gz
[ ! -r "$inputfile" ] && echo "bad input for $SUBJ: $inputfile DNE" && exit 1

if [ -d $SUBJECTS_DIR/$SUBJ ]; then
     echo "$SUBJ: have $SUBJECTS_DIR/$SUBJ "
     echo "WARNING: i dont know if this works!!!"
     echo "         remove $SUBJECTS_DIR/$SUBJ to restart instead"
     cmd="recon-all  -all -s $SUBJ -no-isrunning -make all"
else
     cmd="recon-all  -all -s $SUBJ -i  $inputfile"
fi
[ -n "$DRYRUN" ] && echo $cmd || eval $cmd
