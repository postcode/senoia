module ApplicationHelper

  def form_builder_for(obj)
    simple_form_for obj do |f|
      return f
    end
  end
  
end
