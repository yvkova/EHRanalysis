#!/bin/sh
#$ -S /bin/sh

#$ -M yevgeniya.kovalchuk@kcl.ac.uk
#$ -m be

# Set the location of the stdout and stderr
#$ -o /isilon_home/ykovalchukbrc/scratch/data/clustering/my-sge-output
#$ -e /isilon_home/ykovalchukbrc/scratch/data/clustering/my-sge-output

# Choose the queues - this can be one queue, or multiple queues, separated by a comma
#$ -q short.q,long.q,bignode.q

# Declare how much memory is required PER slot - default is 2Gbytes
#$ -l h_vmem=82G

# Copy your environment
#$ -V
#$ -cwd

# Declare how many threads are required - default is 1 thread
##$ -pe multi_thread 1


# The command you wish to run
Rscript generateFeatures.r
