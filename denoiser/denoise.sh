#!/bin/sh
#use this script to scrub data using fmriprep parameters and output
#python script provided via https://github.com/arielletambini/denoiser


#Set HOME_DIR to the parent directory that includes "denoise" and "derivatives/fmriprep"
#MRI_Data
#|_____derivatives
#|		|_____fmriprep
#|_____denoise
#

STUDY_DIR=/mnt/munin3/Samanez-Larkin/${1}
HOME_DIR=${STUDY_DIR}/Data/MRI_Data

for i in {0..9}; do
	for j in {0..9}; do
		for k in {0..9}; do
			for t in 2step; do
				s=1${i}${j}${k}
				for r in 1 2 3 4 5 6 7 8; do
					if [ -f "${HOME_DIR}/derivatives/fmriprep/sub-${s}/func/sub-${s}_task-${t}_run-0${r}_bold_space-MNI152NLin2009cAsym_preproc.nii.gz" ]; then
						input=${HOME_DIR}/derivatives/fmriprep/sub-${s}/func/sub-${s}_task-${t}_run-0${r}_bold_space-MNI152NLin2009cAsym_preproc.nii.gz
						confounds=${HOME_DIR}/derivatives/fmriprep/sub-${s}/func/sub-${s}_task-${t}_run-0${r}_bold_confounds.tsv
						if [ ! -d "${HOME_DIR}/denoise/sub-${s}" ]; then
							mkdir ${HOME_DIR}/denoise/sub-${s}
						fi
						out_dir=${HOME_DIR}/denoise/sub-${s}
						echo "Running denoiser on subject ${s} run ${r}"
						echo "sub-${s}_task-${t}_run-0${r}">>${out_dir}/denoise_info.txt
						python ${HOME_DIR}/denoise/denoiser/run_denoise.py --col_names CSF WhiteMatter stdDVARS FramewiseDisplacement X Y Z RotX RotY RotZ --out_figure_path ${out_dir}/figures_task-${t}_run-0${r} ${input} ${confounds} ${out_dir}
						echo "Parameters denoised: CSF WhiteMatter stdDVARS FramewiseDisplacement X Y Z RotX RotY RotZ">>${out_dir}/denoise_info.txt
					fi
				done
			done
		done
	done
done
