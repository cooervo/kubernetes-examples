# Use the official Node.js 21 image as the base image
FROM node:21-alpine

# Set the working directory in the container
WORKDIR /app

# Install Express using npm
RUN npm install express

# Copy your app.js file to the working directory
COPY app.js /app

# Expose the port your application will listen on
EXPOSE 3000

# Define the command to start your Express server
CMD ["node", "app.js"]
