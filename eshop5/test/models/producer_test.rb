require 'test_helper'

class ProducerTest < ActiveSupport::TestCase
  test "failing_create" do
    producer = Producer.new
    assert_equal false, producer.save
    assert_equal 2, producer.errors.count
    assert producer.errors[:name]
  end
  
  test "create" do
    producer = Producer.new(
      :name => 'Warner Bros'
    )
    assert producer.save
  end
end
