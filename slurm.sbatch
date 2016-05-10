#!/bin/bash -l
#
#========================================
# DESCRIPTION
#========================================
# The script runs a simple xclock GUI using Shifter
#
# Input files:
# 
# Output file:
#  $SLURM_JOB_ID.out
#
#========================================
# SLURM VARIABLES (APPLICATION SPECIFIC)
#========================================
#SBATCH --job-name="shifter-xclock"
#SBATCH --time=00:05:00
#SBATCH --nodes=1
#SBATCH --x11=all
#SBATCH --gres=gpu
#SBATCH --image=docker:lichinka/shifter-xclock:0.1
#===================================
# SETUP (APPLICATION SPECIFIC)
#===================================
XRUN_DIR=${SCRATCH}/.shifter.${SLURM_JOB_ID}
XRUN_PORT=":$( echo ${DISPLAY} | cut -d':' -f2 )"
export XSOCK=${XRUN_DIR}/.X11-unix
export XAUTH=${XRUN_DIR}/.xauth

#
# create a new magic cookie for the container to access host's X
#
xauth nlist ${XRUN_PORT} | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge - > /dev/null 2>&1

#========================================
# RUN AND CHECK (APPLICATION SPECIFIC)
#========================================
export XAUTHORITY=${XAUTH}

srun shifter 

#docker run --rm=true                            \
#            -it                                 \
#            -e DISPLAY=${DISPLAY}               \
#            -e XAUTHORITY=${XAUTH}              \
#            -v ${XSOCK}:${XSOCK}                \
#            -v ${XAUTH}:${XAUTH}                \
#            -P                                  \
#            shifter-xclock:0.1
