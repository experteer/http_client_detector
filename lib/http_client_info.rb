module Rack
  class HttpClientInfo < ::Hash

    def load_from_raw_data(raw_data)
      raw_data.each do |key, value|
        if %w{phone robot status service_response message}.include?(key.to_s)
          self[key.to_sym] = value
        end
      end

      unless ok?
        self.merge! error_fallback_device_info
      end

      self.freeze
    end

    def ok?
      self[:status] == 'ok'
    end

    def phone?
      !!self[:phone]
    end

    def robot?
      !!self[:robot]
    end

    private

    def error_fallback_device_info
      {:phone => false, :robot => false}
    end

  end
end