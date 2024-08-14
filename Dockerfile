FROM node:latest as builder

RUN mkdir -p /app
WORKDIR /app

COPY package*.json ./
# Installer les dépendances sans conflits
RUN npm install --legacy-peer-deps

COPY . .

# Installation de Angular CLI localement
RUN npm install @angular/cli --legacy-peer-deps

# Ajouter la variable d'environnement pour contourner le problème OpenSSL
ENV NODE_OPTIONS=--openssl-legacy-provider

# Construction de l'application Angular
RUN npm run build --prod

CMD ["npm", "start"]

# Phase de production avec Nginx
FROM nginx:alpine
COPY src/nginx/etc/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/angular8-crud-demo /usr/share/nginx/html