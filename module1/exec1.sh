#!/bin/bash
# Do Exercise 1 ~ Linux basics
# By: Raymund C. Delfin

# Usage:
# ./exec1.sh test1 /var/log/

NEW_DIR=/tmp/$1
LOG_FILES=$2
CURRENT_DIR=$PWD

# create new directory to /tmp/ directory
# ex: `test` as 1st args will create /tmp/test/
function create_dir {
	if [[ ! -d $NEW_DIR ]]; then
		mkdir -p $NEW_DIR
	fi
	echo "created directory: $NEW_DIR"
}

# copy any log files to newly created directory
function copy_logs {
	rsync -avm --include='*.log' -f 'hide,! */' $LOG_FILES $NEW_DIR
	ls $NEW_DIR
}

# rename files in current directory
function rename_current_dir {
	current_dir=$1
	for file in $current_dir/*.log; do
		fn=${file%.*} # get file name
		fz=$(stat -c%s $file) # get file size
		new_file="${fn}_$fz.log"
		mv $file $new_file
		echo "New file for $file is $new_file"
	done
	return
}

# rename each files with the file size to end of the filename
function rename_files {
	echo "Renaming files in $NEW_DIR"
	
	# Rename in base redirectory
	rename_current_dir $NEW_DIR
	for dir in "$NEW_DIR"/*/; do
		dir=${dir%*/}
		echo "Current directory:  ${dir}"
		
		# rename throu all directories
		rename_current_dir ${dir}
	done
}

# call creating new directory
create_dir

# call copying log files
copy_logs

# call renaming file names
rename_files

# archive files
tar -cvzf "/tmp/${1}.tar.gz" "$NEW_DIR/"

# send to email
echo "Message Body Here" | mail -s "Archived Logs for ${1}" raymund.delfin@zeald.com -A /tmp/${1}.tar.gz
