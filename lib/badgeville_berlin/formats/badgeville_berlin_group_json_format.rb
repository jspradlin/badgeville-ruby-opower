require 'active_support/json'
require "badgeville_berlin/version"

module BadgevilleBerlinGroupJsonFormat
  extend BadgevilleBerlinJsonFormat
  extend self

  def decode(json)
    return unless json
    json = ActiveResource::Formats.remove_root(ActiveSupport::JSON.decode(json))

    if json.kind_of?(Array) || !json.has_key?('data')
      json
    else
      if json['data'].kind_of?(Array)
        json['data'].each do |group|
          if group['rewards'].present?
            group['rewards'] = group['rewards'].values
          end
        end
      end
      json['data']
    end

  end

end