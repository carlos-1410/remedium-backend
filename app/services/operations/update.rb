module Operations
  class Update
    def initialize(resource, params:)
      @params = params
      @resource = resource
    end

    def call
      update_resource
    end

    private

    attr_reader :params, :resource

    def update_resource
      response = resource.update_attributes_with_response(**params)

      return Response.success(resource) if response.success?

      Response.failure(resource.errors.full_messages.to_sentence)
    end
  end
end
