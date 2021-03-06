#!/bin/bash

# /***
# * 服务端启动关闭脚本
# * @author manistein
# * @since 2019-04-19
# */

parentPath=$(dirname $(pwd))

function start_process() {
	ps -o command -C mono | grep "$parentPath/spark-server/server/bin/Debug/battle-server.exe $1" &> /dev/null
	[ $? -eq 0 ] && echo "进程已经存在,禁止重复启动" && return
	echo "mono  $parentPath/spark-server/server/bin/Debug/battle-server.exe $1 &> /dev/null &"
	nohup mono $parentPath/spark-server/server/bin/Debug/battle-server.exe $1 &> /dev/null &
}

function launch_all() {
	start_process $1
}

function stop_process() {
	echo "killing $1 ..."
	res=`ps aux | grep "$1" | grep -v tail | grep -v grep | awk '{print $2}'`
	[ "$res" != "" ] && kill $res
}

function stop_all() {
	stop_process $1
}

if [[ "$1" == "start" ]]; then
	launch_all $2
elif [[ "$1" == "stop" ]]; then
	stop_all battle-server.exe
elif [[ "$1" == "restart" ]]; then
	stop_all battle-server.exe
	launch_all $2
else
	echo "不存在$1指令"
fi
