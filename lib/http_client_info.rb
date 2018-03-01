module Rack
  class HttpClientInfo < ::Hash

    # @param [Hash] raw_data expects to contain keys: 'verified', 'phone', 'robot'
    # if raw_data is blank, all these values will be set to false (as a fall-back scenario)
    def load_from_raw_data(raw_data)
      debug = raw_data.delete('debug') || raw_data.delete(:debug) || { }
      data = raw_data
      data.each do |key, value|
        self[key.to_sym] = value
      end
      debug.each do |key, value|
        self[key.to_sym] = value
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
