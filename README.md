To use your Power-On-Demand (POD) license with STAR-CCM+ try this: login as interactive session with graphics

    ssh -X user@Hyak.washington.edu
    qsub -W group_list=hyak-stf -I -V -l nodes=1:ppn=16,feature=intel

Next, start STAR-CCM+ with some extra arguments for POD license:

    module load starccm_10
    starccm+ -power -podkey Your-POD-Key-HERE

To use POD licence for batch jobs you will need to set up a ssh tunnel from your login node. For Login Node = loginA use:

    ssh -g -f -N -L 1999:flex.cd-adapco.com:1999 -L 2099:flex.cd-adapco.com:2099 loginA.hyak.local 

In the Script for Batch Jobs add licence path:

    module load starccm_10  
    starccm+ -np ${PBS_NP} -batch -licpath 1999@loginA.hyak.local -power -podkey Your-POD-Key-HERE -machinefile ${PBS_NODEFILE}  YOUR-SIM-FILE.sim >& log.file

Included here is an example of complete PBS script to submit batch job to the queuing system: [submit-job-Hyak.sh] The job can be submitted by running command "qsub ./Hyak-submit-job.sh". Also you will notice a STAR-CCM+ macro is 
used to automatically mesh and then run the simulation: [macroMeshAndRun.java]. This is helpful if using the "backfill" queue on Hyak where it is possible that your job can be interrupted at any time. Hyak will automatically 
restart your job and continue running up to the walltime limit you request.  BE CAREFUL that your simulation is setup to automatically save intermediate time steps/iterations so that it does not re-start from a blank mesh or 
solution. The STAR-CCM+ user guide details how to setup "automatically saving".

Note ... there seems to be some problem when trying to create a mesh when running on the backfill, you may experience errors related to running out of memory.  If this occurs try using an interactive session to build your mesh, 
then you can submit a batch job to the backfill with mesh already made, and it should run no problem.
