require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  test "response are equal" do
    response_one   = Response.success(1)
    response_two   = Response.success(1)

    assert_equal response_one, response_two
  end

  test ".map" do
    res = Response.success(1)
    failed = Response.failure(1).map { _1 + 1 }
    mapped = res.map { _1 + 1 }
    assert_equal mapped, Response.success(2)
    assert_equal res, Response.success(1)
    assert_equal failed, Response.failure(1)
  end

  test ".map_error" do
    res = Response.failure(1)
    succeeded = Response.success(1).map_error { _1 + 1 }
    mapped = res.map_error { _1 + 1 }
    assert_equal mapped, Response.failure(2)
    assert_equal res, Response.failure(1)
    assert_equal succeeded, Response.success(1)
  end

  test "response are different due the value" do
    response_one   = Response.success(1)
    response_two   = Response.success(2)

    assert_not_equal response_one, response_two
  end

  test "response are different due the the sucess" do
    response_one   = Response.success(1)
    response_two   = Response.failure(1)

    assert_not_equal response_one, response_two
  end

  test "and then with success pass the response" do
    sum = ->(x, y) { Response.success(x + y) }

    step_one   = Response.success(1)
    step_two   = Response.success(2)
    step_three = Response.success(3)

    process = step_one
      .and_then { |value| sum.call(value, step_two.value) }
      .and_then { |value| sum.call(value, step_three.value) }

    assert process.success?
    assert_equal process.value, 6
  end

  test "and then with success run step three" do
    step_one = Response.success("step_one")
    step_two = Response.success("step_two")
    step_three = Response.success("step_three")

    response = step_one
      .and_then { step_two }
      .and_then { step_three }

    assert response.success?
    assert_equal response.value, "step_three"
  end

  test "and then with failure on step two" do
    step_one = Response.success("step_one")
    step_two = Response.failure("step_two")
    step_three = Response.success("step_three")

    response = step_one
      .and_then { step_two }
      .and_then { step_three }

    assert response.failure?
    assert_equal response.value, "step_two"
  end

  test "and then with success run step two" do
    step_one = Response.success("step_one")
    step_two = Response.success("step_two")

    response = step_one.and_then { step_two }

    assert response.success?
    assert_equal response.value, "step_two"
  end

  test "and then with failure does not run step two" do
    step_one = Response.failure("step_one")
    step_two = Response.success("step_two")

    response = step_one.and_then { step_two }

    assert response.failure?
    assert_equal response.value, "step_one"
  end

  test "success builder" do
    response = Response.success(value_response)

    assert response.success?
    assert_equal response.value, value_response
  end

  test "failure builder" do
    response = Response.failure(value_response)

    assert response.failure?
    assert_equal response.value, value_response
  end

  test "syntaxt suggar initializer" do
    response = Response.success(value_response)

    assert response.is_a?(Response)
  end

  test "success is true with true as parameter" do
    response = Response.new(success: true, value: value_response)

    assert response.success?
    assert_not response.failure?
    assert_equal value_response, response.value
  end

  test "success is false with false as parameter" do
    response = Response.new(success: false, value: value_response)

    assert_not response.success?
    assert response.failure?
    assert_equal value_response, response.value
  end

  test "success is false with non true as parameter" do
    response = Response.new(success: "true", value: value_response)

    assert_not response.success?
    assert response.failure?
    assert_equal value_response, response.value
  end

  test "on failure not excuted if success" do
    on_failure_executed = false

    Response
      .success("ok")
      .on_failure { on_failure_executed = true }

    assert_not on_failure_executed
  end

  test "on failure excuted if failure" do
    on_failure_executed = false

    Response
      .failure("error")
      .on_failure { on_failure_executed = true }

    assert on_failure_executed
  end

  test "on failure does not change the response" do
    response = Response
      .failure("error")
      .on_failure { Response.success("ok") }

    assert response.failure?
  end

  test "ensure executed if success" do
    ensure_executed = false

    Response
      .success("ok")
      .ensure { ensure_executed = true }

    assert ensure_executed
  end

  test "ensure executed if failure" do
    ensure_executed = false

    Response
      .failure("error")
      .ensure { ensure_executed = true }

    assert ensure_executed
  end

  test "ensure with failure does not run step two but runs ensure" do
    step_one = Response.failure("step_one")
    step_two = Response.success("step_two")

    compound_response = step_one
      .and_then { step_two }
      .ensure { |response| response.with_meta("👋") }

    assert compound_response.failure?
    assert_equal compound_response.value, "step_one"
    assert_equal "👋", compound_response.meta
  end

  test "with meta populates meta" do
    response = Response.success("ok")

    response.with_meta("👋")

    assert_equal "👋", response.meta
  end

  test "with meta populates meta and returns self" do
    response = Response.success("ok")

    response_copy = response.with_meta("👋")

    assert_equal "👋", response_copy.meta
  end

  test "value bang returns the value on success" do
    response = Response.success("ok")

    assert_equal "ok", response.value!
  end

  test "value bang raises excepton on failure" do
    response = Response.failure(error: :whatever)

    exception = assert_raises Response::ValueError do
      response.value!
    end

    assert_equal "{:error=>:whatever}", exception.message
  end

  test "on success returns original response" do
    original_response = Response.success("ok")
    on_success_response = original_response.on_success { "on success output" }

    assert_equal original_response, on_success_response
  end

  test "on success runs block on previous success" do
    on_success_executed = false

    Response
      .success("ok")
      .on_success { on_success_executed = true }

    assert on_success_executed, "on_success block should have executed when successful."
  end

  test "on success does not execute on failure" do
    on_success_executed = false

    Response
      .failure("error")
      .on_success { on_success_executed = true }

    assert_not on_success_executed, "on_success block shouldn't have executed when failed."
  end

  test "or else basic usage" do
    triple = ->(x) { Response.success(x * 3) }
    err = ->(x) { Response.failure(x) }

    assert_equal Response.success(2).or_else(&triple).or_else(&triple), Response.success(2)
    assert_equal Response.success(2).or_else(&err).or_else(&triple), Response.success(2)
    assert_equal Response.failure(3).or_else(&triple).or_else(&err), Response.success(9)
    assert_equal Response.failure(3).or_else(&err).or_else(&err), Response.failure(3)
  end

  test "or else executed if failure" do
    flag = false

    Response
      .failure(value_response)
      .or_else { flag = true }

    assert flag
  end

  test "or else not executed if success" do
    flag = false

    Response
      .success(value_response)
      .or_else { flag = true }

    assert_not flag
  end

  test "or else returns a value" do
    value = Response
      .failure(value_response)
      .or_else { :ok }

    assert_equal :ok, value
  end

  test "or else returns a chainable response" do
    response = Response
      .failure(value_response)
      .or_else { Response.success(1) }
      .and_then { |value| Response.success(value + 1) }

    assert_kind_of Response, response
    assert response.success?
    assert_equal 2, response.value
  end

  test "or else dont break the chain if success" do
    flag = false

    response = Response
      .success(value_response)
      .or_else { Response.success(2) }
      .on_failure { flag = true }

    assert_kind_of Response, response
    assert response.success?
    assert_not flag
    assert_equal value_response, response.value
  end

  private

  def value_response
    "whatever"
  end
end
