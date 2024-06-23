class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  class << self
    def find_with_response(id, includes: nil)
      find_wrapper(id, includes) { includes(includes).find(id) }
    end

    def find_wrapper(id, _includes)
      Response.success(yield)
    rescue ActiveRecord::RecordNotFound => _e
      Response.failure("Cannot find #{name} with id: #{id}")
    end
  end

  def save_with_response(**args)
    assign_attributes(args)
    if save
      Response.success(self)
    else
      Response.failure(errors.details)
    end
  end

  def update_attributes_with_response(args)
    if errors.details.empty? && update(args)
      Response.success(self)
    else
      Response.failure(errors.details)
    end
  end

  def update_with_changes_response(args)
    assign_attributes(args)
    meta = success_meta_message(changes)
    response = save_with_response

    return response if response.failure?

    Response.success(self, meta:)
  end

  def destroy_with_response
    if destroy
      Response.success(self)
    else
      Response.failure(errors.details)
    end
  end

  private

  def response_success
    Response.success(self)
  end

  def response_failure
    Response.failure(errors.full_messages.to_sentence)
  end

  def success_meta_message(changes)
    message = changes.sort.map do |key, value|
      { "#{key}": { old: value.first, new: value.last } }
    end
    { message: }
  end
end
