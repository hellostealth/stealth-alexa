# coding: utf-8
# frozen_string_literal: true

require 'digest'

module Stealth
  module Services
    module Alexa
      class MessageHandler < Stealth::Services::BaseMessageHandler

        attr_reader :service_message, :params, :headers

        def initialize(params:, headers:)
          @params = params
          @headers = headers
        end

        def coordinate
          # Alexa requires an inline response
          process
        end

        def process
          @service_message = ServiceMessage.new(service: 'alexa')

          # Load the request attributes
          service_message.sender_id = get_sender_id
          service_message.session_values = get_session_values
          get_request_details

          # Craft the reply
          bot_controller = BotController.new(service_message: service_message)
          bot_controller.route

          send_alexa_reply
        end

        private

        def send_alexa_reply
          puts MultiJson.dump(Thread.current[:alexa_reply]).inspect
          MultiJson.dump(Thread.current[:alexa_reply])
        end

        def get_sender_id
          Digest::MD5.hexdigest(params.dig('session', 'user', 'userId'))
        end

        def get_session_values
          params.dig('session', 'attributes')
        end

        def get_request_details
          case params.dig('request', 'type')
          when 'CanFulfillIntentRequest'
            Stealth::Logger.l(topic: "alexa", message: "CanFulfillIntentRequest received.")
            # Not yet implemented
          when 'LaunchRequest'
            service_message.timestamp = DateTime.parse(params.dig('request', 'timestamp'))
            service_message.locale = params.dig('request', 'locale')
            service_message.payload = 'LaunchRequest'
            Stealth::Logger.l(topic: "alexa", message: "LaunchRequest received.")
          when 'IntentRequest'
            service_message.timestamp = DateTime.parse(params.dig('request', 'timestamp'))
            service_message.locale = params.dig('request', 'locale')
            service_message.payload = params.dig('request', 'intent', 'name')
            Stealth::Logger.l(topic: "alexa", message: "IntentRequest [#{service_message.payload}] received.")

            # Load the slots (if any)
            # Alexa uses the SlotName as the key here 😡
            params.dig('request', 'intent', 'slots')&.each do |slot_name, slot|
              service_message.slots[slot_name] = slot.dig('value')
            end
          when 'SessionEndedRequest'
            service_message.timestamp = DateTime.parse(params.dig('request', 'timestamp'))
            service_message.locale = params.dig('request', 'locale')
            service_message.payload = 'SessionEndedRequest'
            Stealth::Logger.l(topic: "alexa", message: "SessionEndedRequest received.")
          end
        end

      end

      module Extensions
        attr_accessor :slots, :session_values, :locale

        def initialize(service:)
          @slots = @session_values = {}
          @locale = nil

          super
        end
      end
    end
  end

  class ServiceMessage
    prepend Services::Alexa::Extensions
  end

end
