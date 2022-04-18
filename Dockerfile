FROM openjdk:8-alpine

# PROJECT_NAME 填写你的项目名字
ENV PROJECT_NAME doceker-test-1.0.0
# PROJECT_HOME 构建成镜像之后，存放的目录位置
ENV PROJECT_HOME D:/workSpace/dockerSpace/${PROJECT_NAME}

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
RUN mkdir $PROJECT_HOME && mkdir $PROJECT_HOME/logs

ARG JAR_FILE
COPY ${JAR_FILE} $PROJECT_HOME

ENTRYPOINT /usr/bin/java -jar -Xms1536m -Xmx1536m $PROJECT_HOME/$PROJECT_NAME.jar
