
date
 pg_dump --dbname=postgresql://postgres:postgres@127.0.0.1:5432/postgres -Fc > gonso1023.backup 
date
echo DUMP ENDED
 pv gonso1023.backup | zip> gonso1023.zip
date 
echo ZIP ENDED
#rm gonso1022.backup
date
