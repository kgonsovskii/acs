#sudo killall python3#sudo killall python3
cd /home/astra/common/doors/alpy
#pyton3 malwrlog.py &
#python3 maldms.py &
#python3 malemul.py -ch 192.168.0.113   -ac 202,2,1,rr -start add -limit 100000  -lsens open,close,rte  &
python3 malemul.py -ch 192.168.0.96 -regim wait   -ac  77,2,2,rr -start add -limit 10000  -lsens open,close,rte  &
