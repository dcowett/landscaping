# app/helpers/flash_toast_helper.rb
module FlashToastHelper
  def render_turbo_toast
    turbo_stream.prepend "flash", partial: "shared/flash_toast"
  end
end
