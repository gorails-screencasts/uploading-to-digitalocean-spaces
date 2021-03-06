class NotificationRenderer
  attr_reader :view_context, :notification

  def initialize(view_context, notification)
    @view_context = view_context
    @notification = notification
  end

  def render_or_stub
    if Rails.env.development? && template_missing?
      generate_template
    end

    render(
      "notifications/#{notification.notifiable_type.underscore}/#{notification.action.parameterize.underscore}",
      actor: notification.actor,
      action: notification.action,
      notifiable: notification.notifiable
    )
  end

  private

    def template_missing?
      !lookup_context.exists?(
        "#{notification.action}",
        ["notifications/#{notification.notifiable_type.underscore}"],
        true
      )
    end

    def generate_template
      dir_name = "app/views/notifications/#{notification.notifiable_type.underscore}"
      FileUtils.mkdir_p(dir_name)

      full_path = "#{dir_name}/_#{notification.action.parameterize.underscore}.html.erb"
      template = File.new(full_path, "wb")
      template.puts("<%# Available variables: actor, action, notifiable %>")
      template.puts('<%= "#{actor.name} #{action} #{notifiable}" %>')
      template.close
    end
end

<%= NotificiationRenderer.new(self, notification).render_or_stub %>

module NotificationsHelper

  def render_notification(notification)
  end

  private

end

<%= render_notification notification %>
