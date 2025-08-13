# 1. 使用官方推荐的基础镜像
FROM python:3.9

# 2. 按照官方文档，创建并切换到没有特权的 "user"
RUN useradd -m -u 1000 user
USER user

# 3. 设置环境变量，指向新用户的主目录
ENV PATH="/home/user/.local/bin:$PATH"
ENV HOME=/home/user

# 4. 设置工作目录为用户主目录下的 app 文件夹
WORKDIR $HOME/app

# 5. 按照官方文档，复制文件时，使用 --chown 将所有权交给新用户
COPY --chown=user ./requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# 6. 再次使用 --chown 复制所有项目文件
COPY --chown=user . .

# 7. (关键修正) 按照官方文档，创建 /data 目录并赋予它最宽松的权限
#    这确保了运行时的 user 用户，可以写入这个由 root 创建的目录
RUN mkdir -p /data && chmod 777 /data

# 8. 启动命令，与你的项目一致
CMD ["python", "web_server.py", "--host", "0.0.0.0", "--port", "7860"]
