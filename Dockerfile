FROM node:16-buster AS build

WORKDIR /app/
COPY . /app/

RUN npm install && \
    make && \
    npm run build

# -----------------------------------------------------------------------------

FROM nginx:1.21-alpine AS prod

COPY --from=build /app/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www
RUN rm -rf ./*
COPY --from=build /app/build .

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
