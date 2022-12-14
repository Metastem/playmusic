FROM node:alpine AS build

ARG api
ARG pipedapi

WORKDIR /app/

COPY . .

RUN sed -i "s/hyperpipeapi.onrender.com/$api/g" index.html src/scripts/fetch.js

RUN sed -i "s/pipedapi.kavin.rocks/$pipedapi/g" index.html src/scripts/fetch.js

RUN npm install && \
    npm run build

FROM nginx:alpine

COPY --from=build /app/dist/ /usr/share/nginx/html/
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
