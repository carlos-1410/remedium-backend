class Response
  class ValueError < StandardError; end

  attr_reader :value, :meta

  def self.success(value, options = {})
    new(success: true, value: value, meta: options[:meta] || {})
  end

  def self.failure(value, options = {})
    new(success: false, value: value, meta: options[:meta] || {})
  end

  def initialize(success:, value: nil, meta: {})
    @success = success
    @value = value
    @meta = meta || {}
  end

  def value!
    raise ValueError, value if failure?

    value
  end

  def map
    return self if failure?

    self.class.success(yield(value))
  end

  def map_error
    return self if success?

    self.class.failure(yield(value))
  end

  def success?
    @success == true
  end

  def failure?
    !success?
  end

  def and_then
    return self if failure?

    yield(value)
  end

  def or_else
    return self if success?

    yield(value)
  end

  def on_success
    yield(value) if success?

    self
  end

  def on_failure
    return self if success?

    yield(value)
    self
  end

  def ensure
    yield(self)
  end

  def with_meta(value)
    @meta = value
    self
  end

  def ==(other)
    value == other.value && success? == other.success?
  end
end
