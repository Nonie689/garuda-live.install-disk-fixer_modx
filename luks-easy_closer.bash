## Init area - Set variables and create functions!!

ask=true

function no_ask {
  ask=false
}


### Area of checking some basics!

echo

## Test more than 1 devices exist!!

if test $(ls -l /dev/mapper/* | wc -l) -eq 1 ; then
   echo "[))> No devices found!"
   echo
   exit 1
fi

echo "Found these devices:"
echo
find /dev/mapper/* -maxdepth 1|grep -v "control"
echo

## Ask to close all devices!!

while true; do

printf "[))> Do you want to close all luks devices? (yes/no): "
read yn
   case $yn in
        yes|y ) echo;echo "ok, trying to closing all devices!";
                no_ask;echo;
                break ;;
        no|n ) echo;break ;;
        * ) echo invalid response;
            echo;;
   esac
done


################################################
##############################################
######## The core of the programm!! #########
############################################
##########################################

## Closing luks devices!!

for device in /dev/mapper/*; do

  case $device in
    /dev/mapper/control ) continue;;
  esac

  if $ask
  then

  while true; do

  printf "[))> LUKS: $device\nDo you want to close this device? (yes/no): "
  read yn
     case $yn in
          yes|y ) echo "Closing: $device";
                  sudo cryptsetup close $device || echo Closing failed!;
                  break;;
          no|n )  break;;
          * ) echo invalid response;
              echo;;
     esac
  done

  else
    echo Closing: $device;
    sudo cryptsetup close $device || echo Closing failed!;
  fi

done

echo
echo All done!
echo
