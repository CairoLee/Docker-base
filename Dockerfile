#############################################################
# 基于 Centos 6 构建的基础镜像, 支持SSH登录, 
# 默认字符集为简体中文(UTF-8).
#############################################################

# 基础镜像
FROM centos:6

# 作者
MAINTAINER CairoLee "cairoliyu@gmail.com"

# 安装命令行工具
RUN yum install -y sed curl tar git passwd sudo vim wget

# 修改系统时区为 UTC+8:00
RUN yum install -y ntpdate && \
\cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装SSH服务并赋予 root 账号初始密码
RUN yum install -y openssh-server openssh-clients && \
sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
mkdir /var/run/sshd && \
echo 'root:docker-base' | chpasswd

# 中文语言支持
RUN yum -y install kde-l10n-Chinese && \
yum -y reinstall glibc-common && \
sed -i 's/LANG="en_US.UTF-8"/LANG="zh_CN.UTF-8"/g' /etc/sysconfig/i18n && \
echo 'SUPPORTED="zh_CN.UTF-8:zh_CN:zh:en_US.UTF-8:en_US:en"' >> /etc/sysconfig/i18n

# 清理工作
RUN rm -rf /root/*
 
# 暴露端口
EXPOSE 22

# 启动SSH服务
CMD ["/usr/sbin/sshd", "-D"]

#############################################################