FROM node:lts-alpine

RUN set -ex && mkdir /app
RUN apk add --no-cache python3 youtube-dl \
	&& wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp \
	&& chmod a+rx /usr/local/bin/yt-dlp

COPY ./precompiled/* /app/
COPY ./*.crt /app/
COPY ./*.key /app/

ENV SIGN_CERT /app/server.crt
ENV SIGN_KEY /app/server.key
ENV NODE_ENV production

# 激活无损音质获取
ENV ENABLE_FLAC true
# 在其他音源搜索歌曲时携带专辑名称
ENV SEARCH_ALBUM true

WORKDIR /app
# 配置端口
EXPOSE 8080 8081
# 使用严格模式、修改音源列表
ENTRYPOINT ["node", "app.js", "-s", "-o", "pyncmd kuwo kugou bilibili"]
