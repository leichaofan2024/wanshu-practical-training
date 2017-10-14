module ApplicationHelper
    def datepicker_input(form_for, field)
        content_tag :td, data: { :provide => 'datepicker', 'date-format' => 'yyyy-mm-dd', 'date-autoclose' => 'true' } do
            form_for.text_field(field, class: 'form-control', placeholder: 'YYYY-MM-DD')
        end
    end
end
