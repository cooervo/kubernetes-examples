# Use an official Node.js runtime as a parent image
FROM node:20.10.0

# Set the working directory to /app
WORKDIR /app

# Install app dependencies
RUN npm install express

# Bundle app source
COPY . .

# Expose port 80
EXPOSE 80

# Entrypoint runs the Node.js application
ENTRYPOINT ["node", "app.js"]

# CMD specifies the default response text
CMD ["use Docker CMD or Kubernetes spec.containers.args to override my response"]