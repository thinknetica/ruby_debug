# Use the official Ruby image as the base image
FROM ruby:3.1.4

# Set the working directory inside the container
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y nodejs && \
    gem install bundler

# Copy Gemfile and Gemfile.lock to the working directory
COPY Gemfile Gemfile.lock ./

# Copy the rest of the application code
COPY . .

# Install gems
# RUN bundle config set --local path 'vendor/bundle'
RUN bundle install --path '/app/vendor/bundle'

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]