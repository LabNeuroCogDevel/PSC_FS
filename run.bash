#!/usr/bin/env bash

# queue up all freesurfer runs

# eventaull runs e.g.
# SUBJ=10124_20060803 DRYRUN=1 bash fs_batch_cmd_cog.bash

# 20190923 - add study to options
[ -z "$1" ] && study="7t" || study="$1"
case $study in 
  7t)
	subjlist=scratch/T1/sub-*/
	export SUBJECTS_DIR=$SCRATCH/FS
        batch_script=fs_batch_cmd.bash
	;;
  cog) 
	subjlist=scratch/cog/T1/1*_2*.nii.gz
	export SUBJECTS_DIR=$SCRATCH/cog/FS
        batch_script=fs_batch_cmd_cog.bash
        ;;
  *)
       echo "unkown study: '$1'"
       exit 1;;
esac

for sub_dir in $subjlist; do 
   # get just the final directory, take out sub- part
   export SUBJ=$(basename ${sub_dir/sub-/} .nii.gz)
   # define where to save the logs
   logfile=$SCRATCH/log/log-$SUBJ.txt

   # does the directory exist already?
   [ -d $SUBJECTS_DIR/$SUBJ ] && echo "$SUBJECTS_DIR/$SUBJ exists" && continue

   # check that subject doesn't already exist
   # squeue -A $(id -gn) # find name switch
   squeue -A $(id -gn) -o %.15j -h | grep $SUBJ && echo "$SUBJ in queue"  && continue

   # just pring subject we need to run
   [ -n "$DRYRUN" ] && echo "$SUBJ (DRYRUN, not running)" && continue

   # submit job to batch queue
   sbatch -o $logfile -e $logfile -J $SUBJ $batch_script 
   
   echo $logfile
done

