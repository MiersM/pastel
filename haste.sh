#!/bin/bash
# Please install the following before running this script:
# curl, xclip and xdg-open


HASTE_URL="https://hastebin.com/"
HASTE_UPLOAD_URL=$HASTE_URL'documents/'

raw=false
noclip=true
browser=false

function help() {
        echo ""
        echo "  -r, --raw"
        echo "  prints the raw link"
        echo "" 
        echo "  -n, --noclip"
        echo "  prevents this script from overriding your latest clipboard"
        echo ""
        echo "  -b, --browser"
        echo "  opens the links in your default browser"
        echo ""
        exit
}

function haste() {
	contents=$(cat $1)
	
	# TODO: check if file exists?
	
	echo $(curl -X POST -s -d "$contents" $HASTE_UPLOAD_URL)
}

function makeUrl() {
	code=$(echo "$1" | awk -F '"' '{print $4}')
	
	if [ $2 = true ]
	then
		url=$HASTE_URL'raw/'$code
	else
		url=$HASTE_URL$code
	fi
	
	echo $url
}

until [ -z $1 ]
do
	case $1 in	
			-h | --help 	)
				help
				;;
			
			-r | --raw 	    )
				raw=true
				;;
				
			-n | --noclip   )
				noclip=false
				;;

                        -b | --browser  )
                                browser=true
                                ;;
                
			*        		)
				result=$(haste $1)
				url=$(makeUrl $result $raw)

				echo $url
				
				if [ $noclip = false ]
				then
					echo "Copying to clipboard..."
					echo "$url" | xclip -sel clip
				fi

                                if [ $browser = true ]
                                then
                                        $(xdg-open $url)
                                        echo "Opening in browser..."
                                fi
				;;
		esac
	shift
done

