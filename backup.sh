#!/bin/bash

#Variable Declaration

backupdir=""
targetdir=""
compformat="tar"
filename=""

#Grab User Arguments

for arg in "$@"
do
        case $arg in
                -b|--backupdirectory)
                backupdir="$2"
                shift
                ;;
                -t|--targetdirectory)
                targetdir="$2"
                shift
                ;;
                -c|--compressionformat)
                compformat="$2"
                shift
                ;;
                -f|--filename)
                filename="$2"
                shift
                ;;
                *)
                bloat+=("$1")
                shift
                ;;
        esac
done

#User Directory Input Check

if [[ $backupdir == "" ]]; then echo "Backup Directory not specified" && exit #Is it declared by user?
elif [ -d $backupdir ]; then echo "Backup Directory Selected: $backupdir" #Does it exist?
else echo "Backup Directory specified does not exist" && exit; fi

if [[ $targetdir == "" ]]; then echo "Target Directory not specified" && exit #Is it declared by user?
elif [ -d $targetdir ]; then echo "Target Directory Selected: $targetdir" #Does it exist?
else echo "Target Directory Specified does not exist" && exit; fi

if [[ $filename == "" ]]; then echo "File Name not specified" && exit; fi #Is it declared by user?

#Combine target dir and filename
if [[ "${targetdir: -1}" == "/" ]]; then targetdir+=$filename
else targetdir+="/" && targetdir+=$filename; fi

#Compress and Store

case $compformat in
        "tar")
        if [[ "${filename: -4}" != ".tar" ]]; then targetdir+=".tar"; fi #Add .tar if not already there
        if [ -f $targetdir ]; then echo "Specified target File Name already exists. Please remove or choose another name." && exit; fi #Check for existing file
        tar -zcvf $targetdir $backupdir #Compress
        ;;
        "gzip")
        if [[ "${filename: -3}" != ".gz" ]]; then targetdir+=".gz"; fi #Add .gz if not already there
        if [ -f $targetdir ]; then echo "Specified target File Name already exists. Please remove or choose another name." && exit; fi #Check for existing file
        gzip -crv $backupdir > $targetdir #Compress
        ;;
        "xz")
        if [[ "${filename: -7}" != ".tar.xz" ]]; then targetdir+=".tar.xz"; fi #Add .gz if not already there
        if [ -f $targetdir ]; then echo "Specified target File Name already exists. Please remove or choose another name." && exit; fi #Check for existing file
        tar -cJvf $targetdir $backupdir #Compress
        ;;
        "bzip2")
        if [[ "${filename: -4}" != ".bz2" ]]; then targetdir+=".bz2"; fi #Add .gz if not already there
        if [ -f $targetdir ]; then echo "Specified target File Name already exists. Please remove or choose another name." && exit; fi #Check for existing file
        tar -cjvf $targetdir $backupdir #Compress
        ;;
        *)
        echo "Unsupported compression format. Supported formats include tar, gzip, xz, and bzip2."
        exit
        ;;
esac

echo "Operation Complete. $backupdir Compressed using $compformat to $targetdir."
