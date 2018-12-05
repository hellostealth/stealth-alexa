# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Alexa
      module Version
        def self.version
          File.read(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'VERSION')).strip
        end
      end

      VERSION = Version.version
    end
  end
end
