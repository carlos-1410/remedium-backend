module Api
  module V1
    class SettingsController < BaseController
      def show
        render json: setting,
          root: "setting",
          serializer: Api::V1::SettingSerializer
      end

      def update
        action = Settings::Update.new(setting, params: setting_params).call

        if action.success?
          render json: action.value,
            root: "setting",
            serializer: Api::V1::SettingSerializer
        else
          render_exception(action.value)
        end
      end

      private

      def setting
        @setting ||= Setting.first
      end

      def setting_params
        params
          .require(:setting)
          .permit(:id, :ga_tracking_id, :contact_email, :contact_phone,
            :facebook_url, :instagram_url, :youtube_url,
            :meta_title, :meta_tags, :meta_description)
      end
    end
  end
end
