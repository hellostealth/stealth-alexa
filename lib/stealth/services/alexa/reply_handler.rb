# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Alexa

      class ReplyHandler < Stealth::Services::BaseReplyHandler

        attr_reader :recipient_id, :reply

        def initialize(recipient_id: nil, reply: nil)
          @recipient_id = recipient_id
          @reply = reply
        end

        def speech
          if reply['ssml'].present? && reply['text'].present?
            raise(ArgumentError, 'A speech reply cannot contain booth "text" and "SSML" values.')
          end

          response = generate_alexa_response
          output_speech = generate_speech_response(
            text: reply['text'],
            ssml: reply['ssml'],
            play_behavior: reply['play_behavior']
          )

          response['response'].merge!(output_speech)

          # Session values
          if reply['session_values'].present?
            session_values = generate_session_response(session_values: reply['session_values'])
            response.merge!(session_values)
          end

          # End session
          response['response'].merge!(generate_end_session_response(reply['end_session']))

          # Reprompts
          if reply['reprompt'].present?
            reprompt_response = generate_reprompt_response
            response['response'].merge!(reprompt_response)
          end

          response
        end

        def card
          response = generate_alexa_response

          output_speech = generate_speech_response(
            text: 'Done',
            ssml: nil,
            play_behavior: reply['play_behavior']
          )

          response['response'].merge!(output_speech)

          card = generate_card_response
          response['response'].merge!(card)

          response
        end

        private

          def generate_alexa_response
            {
              'version' => '1.0',
              'response' => { }
            }
          end

          def generate_speech_response(text:, ssml:, play_behavior: nil)
            response = { 'outputSpeech' => { } }

            if ssml.present?
              response['outputSpeech']['type'] = 'SSML'
              response['outputSpeech']['ssml'] = ssml
            else
              if text.size > 8_000
                raise(ArgumentError, 'Speech replies cannot exceed 8000 characters.')
              end

              response['outputSpeech']['type'] = 'PlainText'
              response['outputSpeech']['text'] = text
            end

            if play_behavior.present?
              response['outputSpeech']['playBehavior'] = play_behavior
            end

            response
          end

          def generate_session_response(session_values:)
            session_map = { 'sessionAttributes' => { } }

            session_values.each do |k,v|
              session_map['sessionAttributes'][k] = v
            end

            session_map
          end

          def generate_end_session_response(end_session=false)
            { 'shouldEndSession' => end_session }
          end

          def generate_reprompt_response
            if reply['reprompt'].is_a?(Boolean)
              speech_response = generate_speech_response(
                text: reply['text'],
                ssml: reply['ssml'],
                play_behavior: reply['play_behavior']
              )
            elsif reply['reprompt'].is_a?(Hash)
              speech_response = generate_speech_response(
                text: reply['reprompt']['text'],
                ssml: reply['reprompt']['ssml'],
                play_behavior: reply['reprompt']['play_behavior']
              )
            end

            { 'reprompt': speech_response }
          end

          def generate_card_image_response
            response = { }

            if reply['small_image_url'].present?
              response['smallImageUrl'] = reply['small_image_url']
            end

            if reply['large_image_url'].present?
              response['largeImageUrl'] = reply['large_image_url']
            end

            response
          end

          def generate_card_response
            response = { 'card' => { } }

            case reply['type']
            when 'Simple'
              response['card']['type'] = 'Simple'
              response['card']['title'] = reply['title']
              response['card']['content'] = reply['content']
            when 'Standard'
              response['card']['type'] = 'Standard'
              response['card']['title'] = reply['title']
              response['card']['text'] = reply['content']

              if generate_card_image_response.present?
                response['card']['image'] = generate_card_image_response
              end
            when 'LinkAccount'
              # Todo
            when 'AskForPermissionsConsent'
              # Todo
            end

            response
          end

      end

    end
  end
end
