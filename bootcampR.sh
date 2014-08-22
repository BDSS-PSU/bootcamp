## This is a test PBS script 
# Request 1 processor on 1 node for 1 minute
#
#   Request 1 processors on 1 node
#
#PBS -l nodes=1:ppn=1
#
#   Request 1 minute of walltime
#
#PBS -l walltime=00:01:00
#PBS -l pmem=100mb
#   Request that regular output and terminal output go to the same file
#
#PBS -j oe
#
#   The following is the body of the script. By default, 
#   PBS scripts execute in your home directory, not the 
#   directory from which they were submitted. The following
#   line places you in the directory from which the job
#   was submitted.
#
cd $PBS_O_WORKDIR
#
#   Now we want to run the program "bootcampbatch.R".  "bootcampbatch.R" is in
#   the directory that this script is being submitted from,
#   $PBS_O_WORKDIR.
#
echo " "
echo " "
echo "Job started on `hostname` at `date`"
module load R
Rscript bootcampbatch.R
echo " "
echo "Job Ended at `date`"
echo " "