# coding: utf-8
# frozen_string_literal: true

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
          process
        end

        def process
          @service_message = ServiceMessage.new(service: 'alexa')
          service_message.sender_id = params['From']
          service_message.message = params['Body']

          bot_controller = BotController.new(service_message: service_message)
          bot_controller.route


        end

      end

    end
  end
end
