module Api::V1
  class CommandsController < Api::ApiController
    def show
      render json: prepare_response(command.execute)
    end

    private

    def command
      begin
        "#{params[:id].to_s.capitalize}Command".constantize.execute
      rescue NameError
        DefaultCommand.execute
      end
    end

    def prepare_response(cmd_result)
      {}
    end
  end
end
