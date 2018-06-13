FROM node:8.9-slim

# Create app directory
WORKDIR /var/www

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package.json ./

# RUN npm install
# If you are building your code for production
RUN npm install

# Bundle app source
COPY . .

EXPOSE 8423
CMD [ "npm", "start" ]