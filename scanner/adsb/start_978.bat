:run
rtl_sdr -d 0 -p 11 -f 978000000 - | dump978 | uat2esnt | nc localhost 31005
goto run