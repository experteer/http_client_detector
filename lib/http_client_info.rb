module Rack
  class HttpClientInfo < ::Hash


    # @param [Hash] raw_data expects to contain keys: 'verified', 'phone', 'robot'
    # if raw_data is blank, all these values will be set to false (as a fall-back scenario)
    def load_from_raw_data(raw_data)
      raw_data ||= { }
      %w{phone robot verified is_app}.each do |key|
        self[key.to_sym] = (raw_data[key] == true)
      end

      self.freeze
    end

    def app?
      self[:is_app]
    end

    def verified?
      self[:verified]
    end

    def phone?
      self[:phone]
    end

    def robot?
      self[:robot]
    end

  end
end
