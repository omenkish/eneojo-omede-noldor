# frozen_string_literal: true

require_relative 'noldor/controlled_patch'
require_relative 'noldor/version'
require_relative 'noldor/credentials'
require_relative 'noldor/exceptions'
require_relative 'noldor/http'
require_relative 'noldor/resources'

module Noldor
  class << self
    attr_writer :credentials
  end

  def self.credentials
    @credentials ||= Credentials.new
  end

  def self.configure
    raise 'Expected a block to be passed in' unless block_given?

    yield(credentials)
  end
end
