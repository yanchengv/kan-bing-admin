#!/bin/sh
set -e
#启动unicorn脚本
# Example init script, this can be used with nginx, too,
# since nginx and unicorn accept the same signals

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
APP_ROOT=/dfs/deploy/webadmin_deploy/current
PID=$APP_ROOT/tmp/pids/unicorn.pid
CMD=" unicorn_rails -c  $APP_ROOT/config/unicorn.rb -D  -E production"
INIT_CONF=$APP_ROOT/config/init.conf
action="$1"
set -u

test -f "$INIT_CONF" && . $INIT_CONF

old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1

sig () {
	test -s "$PID" && kill -$1 `cat $PID`
	
}

oldsig () {
	test -s $old_pid && kill -$1 `cat $old_pid`
}

case $action in
start)
        
	
	if( sig 0 && echo >&2);
        then
        echo "------>Unicorn Already Running!" && exit 0
        else
        echo "------>Unicorn Running Success!"
        $CMD
        fi
        ;;
stop)
       if( sig QUIT && exit 0);
        then
        echo "------> Stop Unicorn Succeess!"
        elif(echo >&2)
	    then
        echo "------> Unicorn Not Running!"
     
        fi
        ;;
	#sig QUIT && exit 0

	#echo >&2 "------> Stop Unicorn Succeess!"
	#;;
force-stop)
	sig TERM && exit 0
	echo >&2 "------> Stop Unicorn Succeess!"
	;;
restart|reload)
	sig HUP && echo "------>Unicorn Running Success!" && exit 0
	#echo >&2 "Couldn't reload, starting '$CMD' instead"
	echo >&2 "------>Unicorn Running Success!"
	$CMD
	;;
upgrade)
	if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
	then
		n=$TIMEOUT
		while test -s $old_pid && test $n -ge 0
		do
			printf '.' && sleep 1 && n=$(( $n - 1 ))
		done
		echo

		if test $n -lt 0 && test -s $old_pid
		then
			echo >&2 "$old_pid still exists after $TIMEOUT seconds"
			exit 1
		fi
		exit 0
	fi
	echo >&2 "Couldn't upgrade, starting '$CMD' instead"
	$CMD
	;;
reopen-logs)
	sig USR1
	;;
*)
	echo >&2 "Usage: $0 <start|stop|restart|upgrade|force-stop|reopen-logs>"
	exit 1
	;;
esac
