require 'net/http/persistent'
require 'json'
require 'benchmark'

namespace :threads do
  desc 'Saves avatars for users inline'
  task avatar_inline: :environment do
    puts(Benchmark.measure do
      uri = URI("http://localhost:3000/pages/avatar")
      http = Net::HTTP.new(uri.host, uri.port)
      User.find_each do |user|
        post = Net::HTTP::Post.new(uri)
        post.body = user.email
        response = http.request(post)
        new_avartar_url = JSON.parse(response.body)['avatar_url']
        user.update avatar_url: new_avartar_url
      end
    end)
  end

  desc 'Saves avatars for users in threads'
  task avatar_treads: :environment do
    uri = URI("http://localhost:3000/pages/avatar")
    threads_limit = 4
    threads = []
    User.find_each do |user|
      if threads.count >= threads_limit
        threads.each &:join
        threads = []
      end
      threads << Thread.new(uri, user) do |uri_obj, usr|
        http = Net::HTTP.new(uri_obj.host, uri_obj.port)
        post = Net::HTTP::Post.new(uri_obj)
        post.body = usr.email
        response = http.request(post)
        new_avartar_url = JSON.parse(response.body)['avatar_url']
        usr.update avatar_url: new_avartar_url
      end
    end
    threads.each &:join
  end

  desc 'Saves avatars for users in http pool'
  task avatar_htt_pool: :environment do
    http_persistent = Net::HTTP::Persistent.new(name: "testing")
    request_uri_string = "http://localhost:3000/pages/avatar"

    # uri = URI(request_uri_string)
    # http = Net::HTTP.new(uri.host, uri.port)
    post = Net::HTTP::Post.new(request_uri_string)
    threads_limit = 4
    threads = []
    User.find_each do |user|
      if threads.count >= threads_limit
        threads.each &:join
        threads = []
      end
      threads << Thread.new(http_persistent, post, user, request_uri_string) do |http_p, post_req, usr, url|
        post_req.body = usr.email
        response = http_p.request url, post_req
        data = JSON.parse(response.body)
        new_avartar_url = data['avatar_url']
        # puts "INCONSISTENT!!!! #{data['user']} != #{usr.email}" if data['user'] != usr.email
        usr.update avatar_url: new_avartar_url
      end
      # Thread.new(threads.first) do |f|
      #   sleep 0.02
      #   f.kill
      # end
      threads.each &:join
    end
  end

  desc 'Saves avatars for users in threads with handle_interrupt'
  task avatar_handle_interrupt: :environment do
    uri = URI("http://localhost:3000/pages/avatar")
    http = Net::HTTP.new(uri.host, uri.port)
    post = Net::HTTP::Post.new(uri)
    threads_limit = 2
    threads_data = []
    threads = []
    threads_data << threads
    Thread.new(threads_data) do |td|
      sleep 0.05
      puts 'KILL!!!' + "#{threads_data.last.last.object_id}"
      threads_data.last.last.kill
    end

    users = User.all.to_a
    users.each do |user|
      if threads.count >= threads_limit
        threads.each &:join
        threads = []
        threads_data << threads
      end
      threads << Thread.new(http, post, user) do |http_obj, post_req, usr|
        Thread.handle_interrupt(Exception: :on_blocking) do
          puts "- - - - - - - -- - - - - start #{usr.id} - - - -- - - - "
          new_avartar_url = nil
          post_req.body = usr.email
          Thread.handle_interrupt(Exception: :immediate) do
            response = http_obj.request(post_req)
            new_avartar_url = JSON.parse(response.body)['avatar_url']
          end
        ensure
          Thread.handle_interrupt(Exception: :never) do
            default_avatar_url = "DEFAULT AVATAR URL"
            usr.avatar_url = new_avartar_url || default_avatar_url
            usr.save!
          end
        end
      end
      threads.each &:join
      # users.each &:save
    end
  end

  desc 'Saves avatars for users in threads'
  task activerecord_handle_interrupt: :environment do
    # ActiveRecord::Base.logger = Logger.new(STDOUT)
    Organization.find(1).update!(title: 'start')
    th = Thread.new do
      Thread.handle_interrupt(Exception: :on_blocking) do
        ActiveRecord::Base.connection_pool.with_connection do
          Organization.find(1).update(title: 'first')
          # puts 'updated first'
          sleep 5
          # puts 'after sleep 5'
        ensure
          Thread.handle_interrupt(Exception: :never) do
            # puts 'start handle_interrupt never'
            o =Organization.find(1)
            o.update(title: 'second')
            # puts 'updated second'
            # sleep 2
            # puts "result in DB #{o.reload.title}"
            # sleep 2
            # puts 'finish'
          end
        end
      end
    end
    # sleep 3
    # th.kill
    th.join
  end

  task binding_pry: :environment do
    th = Thread.new do
      Thread.handle_interrupt(Exception: :never) do
        begin
          a = 0
          Thread.handle_interrupt(Exception: :immediate) do
            sleep 2
            a = 1
          end
        ensure
          puts 'all good' if a == 1
          binding.pry
        end
      end
    end
    sleep 1
    th.kill
    sleep 100
  end
end
