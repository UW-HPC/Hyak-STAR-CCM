#!/bin/bash
## --------------------------------------------------------
## NOTE: to submit jobs to Hyak use
##       qsub <script.sh>
##
## #PBS is a directive requesting job scheduling resources
## and ALL PBS directives must be at the top of the script, 
## standard bash commands can follow afterwards. 
## --------------------------------------------------------


## --------------------------------------------------------
## RENAME for your job
## --------------------------------------------------------
#PBS -N dsale-Hyak_jobname


## --------------------------------------------------------
## DIRECTORY where this job is run
## --------------------------------------------------------
#PBS -d /gscratch/stf/dsale/STAR-CCM+/sims-starccm/


## --------------------------------------------------------
## GROUP to run under, or run under BACKFILL
## --------------------------------------------------------
## PBS -W group_list=hyak-motley
## PBS -W group_list=hyak-stf
#PBS -q bf


## --------------------------------------------------------
## NUMBER nodes, CPUs per node, and MEMORY
## --------------------------------------------------------
#PBS -l nodes=1:ppn=16,mem=4gb,feature=intel
## PBS -l nodes=2:ppn=16,mem=60gb,feature=intel
## PBS -l nodes=4:ppn=16,mem=60gb,feature=intel
## PBS -l nodes=8:ppn=16,mem=60gb,feature=intel
## PBS -l nodes=16:ppn=16,mem=60gb,feature=intel

## --------------------------------------------------------
## WALLTIME (defaults to 1 hour, always specify for longer jobs)
## --------------------------------------------------------
#PBS -l walltime=01:59:00


## --------------------------------------------------------
## LOG the (stderr and stdout) job output in the directory
## --------------------------------------------------------
## PBS -j oe -o /gscratch/motley/dsale/job_output/logs
#PBS -j oe -o /gscratch/stf/dsale/job_output/logs


## --------------------------------------------------------
## EMAIL to send when job is aborted, begins, and terminates
## --------------------------------------------------------
## PBS -m abe -M dsale@uw.edu
#PBS -m abe -M sale.danny@gmail.com


## --------------------------------------------------------
## END of PBS commmands ... only BASH from here and below
## --------------------------------------------------------


## --------------------------------------------------------
## LOAD the appropriate environment modules and variables
## --------------------------------------------------------
module load icc_15.0-impi_5.0.1
module load starccm_10


## --------------------------------------------------------
## DEBUGGING information (include jobs logs in any help requests)
## --------------------------------------------------------
## Total Number of nodes and processors (cores) to be used by the job
echo "== JOB DEBUGGING INFORMATION=========================="
HYAK_NNODES=$(uniq $PBS_NODEFILE | wc -l )
HYAK_NPE=$(wc -l < $PBS_NODEFILE)
echo "This job will run on $HYAK_NNODES nodes with $HYAK_NPE total CPU-cores"
echo ""
echo "Node:CPUs Used"
uniq -c $PBS_NODEFILE | awk '{print $2 ":" $1}'
echo ""
echo "ENVIRONMENT VARIABLES"
set
echo ""
echo "== END DEBUGGING INFORMATION  ========================"


## -------------------------------------------------------- 
## Specify the applications to run here
## -------------------------------------------------------- 
starSimFile="mySIMfile"
starMacros="macroMeshAndRun.java"
myPODkey="copy-paste-your-POD-key-here"

## CHANGE directory to where job was submitted (careful, PBS defaults to user home directory)
cd $PBS_O_WORKDIR

## KEEP copy of the initial cleared solution (small file size), 
## and RENAME file used for restart after CHECKPOINTING (this file gets big) 
cp --no-clobber $starSimFile.sim runs.$starSimFile.sim
rm log.*
rm *.sim~

## RUN my simulation file in BATCH MODE
starccm+ -batch $starMacros -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -mpi intel -licpath 1999@login3.hyak.local -power -podkey $myPODkey -batch-report runs.$starSimFile.sim 2>&1 | tee log.$starSimFile
