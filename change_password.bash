
same_pass=false
no_root=false

function ask_root_only {
        if test $u_name == 'root' && ! test -z $PASS1
        then
           ask_same_pass_root
        fi
}
function ask_u_pass_change {
	while true
	do

	printf "[))> Do you want to change $u_name? (yes/no): "
	read yn
	   case $yn in
		yes|y ) echo;echo "Changing password of: $u_name";echo;
		        read_pass $u_name;echo;
		        break ;;
		no|n ) echo;break ;;
		* ) echo invalid response;
		    echo;;
	   esac
	done
}

function ask_same_pass_root {
	while true
	do
	printf "[))> Do you want the same passphrase for root? (yes/no): "
	read yn
	   case $yn in
		yes|y ) echo;echo "Use the same password for root";
		        same_pass=true;
		        break ;;
		no|n ) echo;break ;;
		* ) echo invalid response;
		    echo;;
	   esac
	done
}


function read_pass {
        ask_root_only

	while true
	do
	   if $same_pass
	   then
	      change_pass
	      break
	   fi
	
	echo -n "[))> Enter passphrase: "

	stty -echo
	PASSWORD=""
	PROMPT=""
	CHARCOUNT=0
	while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
	do
	    # Enter - accept password
	    if [[ $CHAR == $'\0' ]] ; then
		break
	    fi
	    # Backspace
	    if [[ $CHAR == $'\177' ]] ; then
		if [ $CHARCOUNT -gt 0 ] ; then
		    CHARCOUNT=$((CHARCOUNT-1))
		    PROMPT=$'\b \b'
		    PASSWORD="${PASSWORD%?}"
		else
		    PROMPT=''
		fi
	    else
		CHARCOUNT=$((CHARCOUNT+1))
		PROMPT='*'
		PASSWORD+="$CHAR"
	    fi
	done

	PASS1=$PASSWORD

	echo
	echo -n "[))> Retype the same passphrase again: "

	PASSWORD=""
	PROMPT=""
	CHARCOUNT=0
	while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
	do
	    # Enter - accept password
	    if [[ $CHAR == $'\0' ]] ; then
		break
	    fi
	    # Backspace
	    if [[ $CHAR == $'\177' ]] ; then
		if [ $CHARCOUNT -gt 0 ] ; then
		    CHARCOUNT=$((CHARCOUNT-1))
		    PROMPT=$'\b \b'
		    PASSWORD="${PASSWORD%?}"
		else
		    PROMPT=''
		fi
	    else
		CHARCOUNT=$((CHARCOUNT+1))
		PROMPT='*'
		PASSWORD+="$CHAR"
	    fi
	done

	stty echo

	PASS2=$PASSWORD

	printf "\n"

	if [[ $PASS1 == $PASS2 ]]
	then
	   change_pass && break
	fi
	echo
	echo "Error, the passwords do not match!"
	echo "Type two times the same password you set for $u_name!!"
	done
}


function change_pass {
	   echo
	   (echo "$PASS1"; echo "$PASS2") | sudo passwd $u_name 2> /dev/null && echo "Password updated successfully!" || echo "Password updating fails!"
}



if ! [[ -z $1 ]]
then
   u_name=$1
   if test $1 == root
   then
      no_root=true
   fi
else
   u_name="$USER"
fi


ask_u_pass_change

if ! $no_root
then
   u_name=root
   ask_u_pass_change
fi

sleep 2.5
