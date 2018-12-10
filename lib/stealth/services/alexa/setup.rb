# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Alexa

      class Setup

        class << self
          def trigger
            Stealth::Logger.l(topic: "alexa", message: "There is no setup needed!")
          end
        end

      end

    end
  end
end
