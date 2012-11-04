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
                template.content_tag(:li) do
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

      def fragment_preview_html

        preview = if object.send("#{method}_uid")
          original_url = object.send(method).url
          if object.send("#{method}_name").match /\.(png|gif|jpe?g)$/
            preview_size = input_html_options[:preview_size] || "72x72#"
            preview_url = object.send(method).thumb(preview_size).url
            template.link_to(template.image_tag(preview_url), original_url)
          else
            template.link_to object.send("#{method}_name"), original_url
          end
        else
          "<div class='no-image'>#{I18n.t("dragonfly.no_image")}</div>".html_safe
        end

        fragment_label_html(:preview) << preview
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
