
### Init area - Set variables!

unset password
unset CHARCOUNT

count_all=0
count=0
failed=-1
exit=true


## Show more than 1 Variable!

for OUTPUT in $(blkid| grep /dev/sd | awk 'BEGIN { FS="[:\" ]" } {print $1 " label-" $4  }' | awk 'BEGIN { FS="label-" } {print $2 }')
do
   sudo cryptsetup isLuks /dev/disk/by-uuid/$OUTPUT &> /dev/null && let "count_all++"
done

if test $count_all -eq 1
then
   echo "[))> No LUKS devices found!"
   exit 1
fi

echo
echo "[))> Found these LUKS devices!"
echo

for OUTPUT in $(blkid| grep /dev/sd | awk 'BEGIN { FS="[:\" ]" } {print $1 " label-" $4  }' | awk 'BEGIN { FS="label-" } {print $2 }')
do
   sudo cryptsetup isLuks /dev/disk/by-uuid/$OUTPUT &> /dev/null && echo "$OUTPUT"
done

echo

echo -n "[))> Enter passphrase: "

stty -echo

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

echo
echo
echo "Trying to open LUKS devices!"
echo
sleep 2

for OUTPUT in $(blkid| grep /dev/sd | awk 'BEGIN { FS="[:\" ]" } {print $1 " label-" $4  }' | awk 'BEGIN { FS="label-" } {print $2 }')
do
    sudo cryptsetup isLuks /dev/disk/by-uuid/$OUTPUT &> /dev/null || continue
    ls /dev/mapper/luks-$OUTPUT &> /dev/null && echo "Device luks-$OUTPUT already exists." && continue
    trap 'false' INT
    echo $PASSWORD | sudo cryptsetup open /dev/disk/by-uuid/$OUTPUT luks-$OUTPUT &> /dev/null && echo "LUKS opened: $OUTPUT -> /dev/mapper/luks-$OUTPUT" || echo "Failed to open LUKS: $OUTPUT"
done


#if ! test $count -eq $failed
#then
#  echo
#  printf "[))> Success: $count\tof $count_all LUKS partitions!!\n"
#  printf "[))> Fails:   $failed\twith this passphrase!!\n"
#  echo
#  echo "---------------------------------------------------------------------"
#  echo
#else
#  exit=false
#  echo
#  echo "[))> Failed to open anyone of the LUKS with this passphrase!"
#  echo
#  echo "---------------------------------------------------------------------"
#  echo
#fi

echo
echo "---------------------------------------------------------------------"
echo "-------  You have these LUKS filesystem that you can use!! ----------"
echo "---------------------------------------------------------------------"
echo
echo "[))> Opened LUKS Swap filesystems!"
echo

lsblk -f --raw | grep -E "luks-" | grep swap

echo
echo "[))> All other opened LUKS filesystems!"
echo

lsblk -f --raw | grep -E "luks-" | grep -v swap

echo "---------------------------------------------------------------------"
echo
echo All done
echo

if $exit
then
  exit
else
  exit 1
fi
