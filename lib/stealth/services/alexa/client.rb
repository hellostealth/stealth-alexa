# coding: utf-8
# frozen_string_literal: true

require 'stealth/services/alexa/message_handler'
require 'stealth/services/alexa/reply_handler'
require 'stealth/services/alexa/setup'

module Stealth
  module Services
    module Alexa

      class Client < Stealth::Services::BaseClient

        attr_reader :reply

        def initialize(reply:)
          @reply = reply
          Thread.current[:alexa_reply] = reply
        end

        def transmit
          Stealth::Logger.l(topic: "alexa", message: "Response sent.")
        end

      end

    end
  end
end
