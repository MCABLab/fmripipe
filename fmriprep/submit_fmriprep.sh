#this is the script you will actually run
# log on to cluster, (unsure if it matters if you use qrsh or not yet), make a folder for scripts, sftp this file and fmriprep.sh into it, cd into it
#USAGE: qsub -v EXPERIMENT=(name of study folder on server) submit_fmriprep.sh
EXPERIMENT=agerl.01

subID=(1002 1004 1008 1009 1014 1018 1019 1021 1024 1029 1030 1032 1035 1037 1039 1041 1045 1047 1049 1050 1051 1053 1060 1066 1067 1069 1073 1079 1080 1081 1084 1085 1087 1096 1097)


for i in 0 1 2 3 4 5 6 12 13 14 15 19 20 21 22 23 29 30 31 32 ;
	do
		declare SUB=${subID[$i]}
		echo $SUB
		qsub -v EXPERIMENT=${EXPERIMENT} ~/scripts/cluster_fmriprep/fmriprep.sh ${SUB}
done
