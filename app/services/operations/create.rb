module Operations
  class Create
    def initialize(resource)
      @resource = resource
    end

    def call
      return Response.failure(resource.errors.full_messages.to_sentence) unless resource.valid?

      create_resource
    end

    private

    attr_reader :resource

    def create_resource
      resource.save_with_response
    end
  end
end
