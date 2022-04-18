#!/bin/bash

#项目占用端口
APP_PORT=8081
# 项目名字
APP_NAME=doceker-test-1.0.0
APP_HOME=D:/workSpace/dockerSpace/${APP_NAME}
APP_OUT=${APP_HOME}/logs

PROG_NAME=$0
ACTION=$1
TAGNAME=$2
PROFILE=$3

# 阿里云仓库命名空间
APP_NAMESPACE=weirdo_workspace
# 推送至阿里云仓库的地址
APP_REGISURL=registry.cn-hangzhou.aliyuncs.com/weirdo_test/weirdo_workspace
APP_RESP=${APP_REGISURL}/${APP_NAMESPACE}/${APP_NAME}-${PROFILE}
# 阿里云账号
APP_USERNAME=weirdo_wu
# 阿里云配置个人容器镜像服务时，设置的密码
APP_PASSWORD=whf0710.

mkdir -p ${APP_HOME}
mkdir -p ${APP_HOME}/logs

usage() {
    echo "Usage: $PROG_NAME {start|stop|restart|push}"
    exit 2
}

start_application() {
    echo "starting java process"
    docker run --log-opt max-size=1024m --log-opt max-file=3 --security-opt seccomp:unconfined -dit --name ${APP_NAME} -p ${APP_PORT}:${APP_PORT} --pid=host -v ${APP_OUT}:/usr/local/${APP_NAME}/logs ${APP_RESP}:${TAGNAME}
    echo "started java process"
}

stop_application() {
    echo "ending java process"
    docker stop ${APP_NAME} && docker rm ${APP_NAME}
    echo "ended java process"
}

push_application() {
    echo "starting image push"
    docker login --username=${APP_USERNAME} --password=${APP_PASSWORD} ${APP_REGISURL}
    echo "docker tag ${APP_RESP}:${TAGNAME} ${APP_RESP}:${TAGNAME}"
    echo "docker push ${APP_RESP}:${TAGNAME}"

    #docker tag 用于给镜像打标签
    docker tag ${APP_RESP}:${TAGNAME} ${APP_RESP}:${TAGNAME}
    # 推送到个人的阿里云仓库
    docker push ${APP_RESP}:${TAGNAME}
    docker images|grep ${APP_RESP}|grep none|awk '{print $3 }'|xargs docker rmi
    echo "ended image push"
}

rmi_application() {
    docker rmi ${APP_RESP}:${TAGNAME}
}

start() {
    start_application
}
stop() {
    stop_application
}
push() {
    push_application
}
rmi() {
    rmi_application
}

case "$ACTION" in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
        stop
        start
    ;;
    slaveRestart)
        stop
        rmi
        start
    ;;
    push)
        push
    ;;
    *)
        usage
    ;;
esac
