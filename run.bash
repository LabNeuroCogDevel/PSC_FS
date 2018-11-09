#!/usr/bin/env bash

echo $logfile
for sub_dir in scratch/T1/sub-*/; do 
   # get just the final directory, take out sub- part
   export SUBJ=$(basename ${sub_dir/sub-/})
   # define where to save the logs
   logfile=$SCRATCH/log/log-$SUBJ.txt

   # does the directory exist already?
   [ -d $SUBJECTS_DIR/$SUBJ ] && echo "file exists" && continue

   # check that subject doesn't already exist
   # squeue -A $(id -gn) # find name switch
    squeue -A $(id -gn) | grep $SUBJ && echo "have name in queue"  && continue

   # submit job to batch queue
    sbatch -o $logfile -e $logfile -J $SUBJ fs_batch_cmd.bash
done

