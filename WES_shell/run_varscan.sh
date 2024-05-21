#!/bin/bash

# config 
source "../config.sh"
source "variants_calling"
conda activate wes-variants-calling
cd ${project_dir}

varscan="/home/${USER}/miniconda3/envs/${env_name}/share/varscan-*/VarScan.jar"

# mkdir
varscan_dir=${project_dir}/variants_calling/varscan
mkdir -p ${varscan_dir} && chmod a+rw ${varscan_dir}

case_IDs_file="${project_dir}/case_IDs.tsv"
while IFS= read -r case_ID
	do
		echo "Processing ${case_ID}"
        run_varscan ${case_ID} > "${varscan_dir}/log/${case_ID}-T.varscan.log" 2>&1 || { echo "Error processing ${case_ID}"; exit 1; }
        python "${tools_dir}/others/send_msg.py" "mutect ${case_ID} done"
	done < "$case_IDs_file"


