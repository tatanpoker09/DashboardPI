# Use the official Ruby image as the base image
FROM ruby:3.2.2-bookworm

# Set the working directory within the container
WORKDIR /app

# Install necessary system dependencies
RUN apt-get update -qq && apt-get install -y build-essential nodejs

# Install Bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock to the container
COPY ../Gemfile Gemfile.lock ./

# Install project dependencies
RUN bundle install

# Install the Smashing gem
RUN gem install smashing

# Install the OpenWeather Ruby client gem
RUN gem install open-weather-ruby-client

# Create a new directory for your Smashing project
RUN smashing new my-project

# Set the working directory to your project
WORKDIR /app/my-project

# Expose the port that Smashing uses
EXPOSE 3030

# Start the Smashing dashboard
CMD ["smashing", "start"]
