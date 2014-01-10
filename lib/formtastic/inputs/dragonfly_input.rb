module Formtastic
  module Inputs

    class DragonflyInput < Formtastic::Inputs::FileInput

      def to_html
        components = input_html_options[:components] || [ :preview, :upload, :remove ]
        input_wrapping do
          fragments_wrapping do
            fragments_label <<
            template.content_tag(:ol) do
              components.map do |component|
                template.content_tag(:li, class: "input component-#{component}") do
                  fragment_html(component)
                end
              end.join.html_safe
            end
          end
        end
      end

      def fragments_wrapping(&block)
        template.content_tag(:fieldset,
          template.capture(&block).html_safe,
          fragments_wrapping_html_options
        )
      end

      def fragments_wrapping_html_options
        { :class => "fragments" }
      end

      def fragments_label
        if render_label?
          template.content_tag(:legend, builder.label(method, label_text, :class => "label"))
        else
          "".html_safe
        end
      end

      def fragment_label_html(fragment)
        text = fragment_label(fragment)
        text.blank? ? "".html_safe : template.content_tag(:label, text, :for => fragment_id(fragment))
      end

      def fragment_id(fragment)
        "#{input_html_options[:id]}_#{fragment}"
      end

      def fragment_label(fragment)
        labels_from_options = options[:labels] || {}
        if labels_from_options.key?(fragment)
          labels_from_options[fragment]
        else
          ::I18n.t(fragment.to_s, :default => fragment.to_s.humanize, :scope => [:dragonfly])
        end
      end

      def fragment_html(fragment)
        send("fragment_#{fragment}_html")
      end

      def fragment_upload_html
        fragment_label_html(:upload) <<
        builder.file_field(method, input_html_options) <<
        builder.hidden_field("retained_#{method}")
      end

      def is_image?(file)
        file.mime_type =~ /png|bmp|gif|tif|jpe?g/
      rescue Dragonfly::DataStorage::DataNotFound
        false
      end

      def fragment_preview_html
        file = object.send(method)
        if file.present?
          if is_image?(file)
            original_url = object.send(method).url
            preview_size = input_html_options[:preview_size] || [ 75, 75 ]
            preview_url = object.send(method).thumb("#{preview_size.first}x#{preview_size.last}#").url
            fragment_label_html(:preview) << template.link_to(template.image_tag(preview_url), original_url)
          else
            fragment_download_html
          end
        else
          fragment_label_html(:preview) << "<div class='no-image'>#{I18n.t("dragonfly.no_image")}</div>".html_safe
        end
      end

      def fragment_download_html
        file = object.send(method)
        download = if file.present?
          original_url = file.url
          name = object.send("#{method}_name") rescue "Download"
          name = name.blank? ? "Download" : name
          template.link_to name, original_url
        else
          "<span class='no-file'>#{I18n.t("dragonfly.no_file")}</span>".html_safe
        end
        fragment_label_html(:download) << download
      end

      def fragment_url_html
        fragment_label_html(:url) <<
        builder.text_field("#{method}_url")
      end

      def fragment_remove_html
        if object.send("#{method}_uid")
          template.content_tag(:label, for: fragment_id(:remove)) do
            builder.check_box("remove_#{method}") <<
            " ".html_safe <<
            I18n.t("dragonfly.remove")
          end
        end
      end

    end

  end
end
