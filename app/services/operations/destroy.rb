module Operations
  class Destroy
    def initialize(resource)
      @resource = resource
    end

    def call
      destroy_resource
    end

    private

    attr_reader :resource

    def destroy_resource
      response = resource.destroy_with_response

      return Response.success(true) if response.success?

      Response.failure(resource.errors.full_messages.to_sentence)
    end
  end
end
