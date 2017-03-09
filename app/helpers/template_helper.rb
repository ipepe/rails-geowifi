module TemplateHelper
  def form_field(resource, attribute)
    content_tag(:div,(
    content_tag(:label, resource.class.human_attribute_name(attribute), class:'control-label')+
        content_tag(:input, nil, {
            class: 'form-control',
            type: 'text',
            value: resource.read_attribute(attribute)
        }.merge(special_attributes_for(resource,attribute)))
    ), class: 'form-group')
  end

  def special_attributes_for(resource, attribute)
    result = {}
    if resource._validators[attribute].any?{|v| v.class.name.ends_with?('PresenceValidator')}
      result[:required]='required'
    end
    if resource._validators[attribute].any?{|v| v.class.name.ends_with?('EmailValidator')}
      result[:type] = 'email'
    end
    result
  end


  def li_link_to(path_symbol)
    path = Rails.application.routes.url_helpers.public_send(path_symbol)
    li_options = {}
    li_options[:class] = 'active' if current_page?(path)
    content_tag(:li, my_link_to(path_symbol), li_options)
  end

  def my_link_to(path_symbol)
    path = Rails.application.routes.url_helpers.public_send(path_symbol)
    link_to(I18n.t("application.navigation.#{path_symbol}"), path)
  end

  def human_attr(class_symbol, attr_name)
    class_symbol.capitalize.to_s.constantize.human_attribute_name(attr_name)
  end

  def human_val(resource, attr_name)
    #TODO: if email? td: a href="mailto:#{@user.email}" = @user.email
    #TODO: if phone_numer? a href="tel: ..."
    if resource.class.defined_enums.keys.include?(attr_name.to_s)
      resource.human_enum_name(attr_name)
    else
      resource.public_send(attr_name)
    end
  end

  def empty_if_zero(value)
    if value == 0
      ''
    else
      value
    end
  end

end

ActionView::Helpers::FormBuilder.module_eval do
  def base_errors
    @template.content_tag(:span, @object.errors[:base].join(",") , class: 'has-error')
  end

  def form_field_for(attribute, *options)
    form_group_classes = ['form-group']
    form_group_content = [self.label(attribute, class: 'control-label'),
                          self.text_field(attribute, class: 'form-control')]
    if @object.errors[attribute].present?
      form_group_content.push(@template.content_tag(:div, @object.errors[attribute].join(","), class: 'help-block'))
      form_group_classes.push('has-error')
    end
    @template.content_tag(:div, (
    form_group_content.reduce(:+)
    ), class: form_group_classes)
  end
end