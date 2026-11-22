FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Holds the build and nothing that serves it: run, it publishes /dist into the volume mounted at
# /srv/frontend, which the nginx service serves (docs/adr/0014).
FROM alpine:3.22
COPY --from=build /app/dist /dist
COPY publish.sh /publish.sh
CMD ["sh", "/publish.sh"]
