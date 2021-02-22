require 'simplecov'
require 'simplecov_small_badge'
SimpleCov.start do
  # add your normal SimpleCov configs
  add_filter "/app/model"
  # call SimpleCov::Formatter::BadgeFormatter after the normal HTMLFormatter
  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCovSmallBadge::Formatter
  ])
end

# configure any options you want for SimpleCov::Formatter::BadgeFormatter
SimpleCovSmallBadge.configure do |config|
  # does not created rounded borders
  config.rounded_border = true
  # set the background for the title to darkgrey
  config.background = '#ffffcc'
end

require 'minitest/autorun'
require 'aws-xray-sdk/emitter/emitter'
require 'aws-xray-sdk/sampling/default_sampler'

if RUBY_PLATFORM == 'java'
  require 'jrjackson'
else
  require 'oj'
end

module XRay
  # holds all testing needed classes and methods
  module TestHelper
    # Emitter for testing that holds all entity it is about to send.
    class StubbedEmitter
      include Emitter

      attr_reader :entities

      def send_entity(entity:)
        @entities ||= []
        @entities << entity
      end

      def clear
        @entities = []
      end
    end

    # The stubbed sampler doesn't spawn threads to call X-Ray service.
    class StubbedDefaultSampler < DefaultSampler
      def start
        # no-op
      end
    end
  end
end
