# ---------------------------------------------------------------------------------------
FROM node:16-buster AS build

WORKDIR /app/
COPY . /app/
RUN npm install && \
    make && \
    npm run build

# ---------------------------------------------------------------------------------------
FROM nginx:1.21-alpine AS prod

WORKDIR /app/
COPY --from=build /app/build/ /app/dist/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
