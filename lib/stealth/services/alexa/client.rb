# coding: utf-8
# frozen_string_literal: true

require 'stealth/services/alexa/message_handler'
require 'stealth/services/alexa/reply_handler'
require 'stealth/services/alexa/setup'

module Stealth
  module Services
    module Alexa

      class Client < Stealth::Services::BaseClient

        attr_reader :alexa_client, :reply

        def initialize(reply:)
          @reply = reply
        end

        def transmit
          response = twilio_client.messages.create(reply)
          Stealth::Logger.l(topic: "twilio", message: "Transmitting. Response: #{response.status}: #{response.error_message}")
        end

      end

    end
  end
end
