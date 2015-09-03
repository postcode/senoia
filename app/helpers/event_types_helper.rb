module EventTypesHelper
  def options_for_event_type_select
    { 
      collection: EventType.order("name ASC"),
      label_method: :name,
      value_method: :id,
      include_blank: false,
      label: false,
      prompt: "(Please select)"
    }
  end
end
