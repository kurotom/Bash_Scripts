#!/bin/bash
# kurotom

usage() {
	echo -e "\n\t$0 [ t | a | s | k | c | p ] -f pdf_original.pdf \n"
	echo -e """\tOptions:\n
	\t-t title
	\t-a author
	\t-s subject
	\t-k keywords
	\t-c creator
	\t-p producer
	"""
}


runProgram() {
	now=$(date +%Y%m%d%H%M%S)
	original=$(echo $file)
	final=$(echo "final-$file")

	echo -e "\n$original --> $final"

	marcas="""[ /Title ("$title")
		/Author ("$author")
		/Subject ("$subject")
		/Keywords ("$keywords")
		/ModDate (D:"$now")
		/CreationDate (D:"$now")
		/Creator ("$creator")
		/Producer ("$producer")
		/DOCINFO pdfmark
	"""

	linkFile=$(readlink -f "$file")

	if [[ -f $linkFile ]]; then
		gs -q -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile="$final" "$original" -c "$marcas"
	else
		echo -e "\a\nFichero origen no existe.\n"
	fi

	echo -e "\a\nFinalizado.\n"
}




file=""
title=""
author=""
subject=""
keywords=""
creator=""
producer=""


while getopts :f:t:a:s:k:c:p: opcion ; do
	case $opcion in
		f)
			file="${OPTARG}"
			;;
		t)
			title=${OPTARG}
			;;
		a)
			author=${OPTARG}
			;;
		s)
			subject=${OPTARG}
			;;
		k)
			keywords=${OPTARG}
			;;
		c)
			creator=${OPTARG}
			;;
		p)
			producer=${OPTARG}
			;;
		*)
			usage
			;;
	esac
done

if [[ ${file} != "" ]]; then
	runProgram
else
	usage
fi



# kurotom
