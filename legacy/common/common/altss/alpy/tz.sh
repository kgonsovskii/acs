sudo killall python3
#sudo killall python3
#cd /home/astra/common/doors/alpy
# nohup python3   tzx1.py -psdcomp astraorel -ch 192.168.0.96  -start poll -startdms y -startwrlog y  &>/dev/null &
 python3   tzx1.py -psdcomp astraorel -ch 192.168.0.96  -start poll -startdms n -startwrlog n  &
python3 maldms.py &
python3 malwrlog.py &
