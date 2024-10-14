class HelpRequestCleaner < ApplicationService
  attr_reader :organization

  def initialize(options)
    @organization = options[:organization]
  end

  def call
    threads_limit = 4
    threads = []
    organization.help_requests.find_each do |hr|
      if threads.count >= threads_limit
        threads.each &:join
        threads = []
      end
      threads << Thread.new(hr) do |help_request|
        help_request.destroy
      end
    end
    threads.each &:join
    true
  rescue
    false
  end
end
