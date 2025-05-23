sudo killall python3
#sudo killall python3
cd /home/astra/common/altss/alpy
python3   maldrv9y.py -psdcomp astraorel -ch 192.168.0.96   -start poll  & 
sleep 3

python3 maldmsy.py &
python3 malwrlog.py &

