module CustomDateTimeFormat
  extend ActiveSupport::Concern

  DEFAULT_DATETIME_FORMAT = "%m/%d/%Y %H:%M %p"

  included do

    def parse_date_time_if_in_preferred_format(date_time)
      if date_time =~ /[0-9]{2}\/[0-9]{2}\/[0-9]{4}/
        DateTime.strptime(date_time, DEFAULT_DATETIME_FORMAT)
      else
        date_time
      end
    end
    
  end

  class_methods do

    def use_custom_datetime_format_for(*attributes)
      Array.wrap(attributes).each do |attribute|
        define_method "#{attribute}=" do |argument|
          super parse_date_time_if_in_preferred_format(argument)
        end
      end
    end
    
  end
end
