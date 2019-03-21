#!/bin/sh
#use this script to mask denoised fMRI data with fmriprep-generated brain mask (and overwrite the denoised data file)
#Set STUDY_DIR to study name 
#Set HOME_DIR to the parent directory that includes "denoise" and "derivatives/fmriprep"
#MRI_Data
#|_____derivatives
#|		|_____fmriprep
#|_____denoise
#
# usage: "sh mask_preproc_data.sh ${STUDY_DIR}"
# example: "sh mask_preproc_data.sh dnd.01"


STUDY_DIR=/mnt/munin3/Samanez-Larkin/${1}
HOME_DIR=${STUDY_DIR}/Data/MRI_Data
DENOISED_DIR=${HOME_DIR}/denoise
FMRIPREP_DIR=${HOME_DIR}/derivatives/fmriprep

for i in {0..9}; do
	for j in {0..9}; do
		for k in {0..9}; do
			s=1${i}${j}${k}
			for t in 2step; do
				for r in 1 2 3 4 5 6 7 8; do
					FILE_PATTERN=sub-${s}_task-${t}_run-0${r}_bold_space-MNI152NLin2009cAsym
					if [ -f "${DENOISED_DIR}/sub-${j}${j}${k}/${FILE_PATTERN}_preproc_NR.nii.gz" ]; then
						echo "masking functional data for sub-${s}_task-${t}_run-0${r}"
						fslmaths ${DENOISED_DIR}/sub-${j}${j}${k}/${FILE_PATTERN}_preproc_NR.nii.gz -mul ${FMRIPREP_DIR}/sub-${s}/func/${FILE_PATTERN}_brainmask.nii.gz ${DENOISED_DIR}/sub-${j}${j}${k}/${FILE_PATTERN}_preproc_NR.nii.gz
					fi
				done
			done
		done
	done
done
