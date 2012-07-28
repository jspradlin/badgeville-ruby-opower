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
        # Modify the json to return rewards as an Array
        # instead of a Hash with the RewardDefinition as
        # the key because the latter will not parse.
        json['data'].each do |group|
          group['rewards'] = group['rewards'].present? ? group['rewards'].values : []
        end
      end
      json['data']
    end

  end

end