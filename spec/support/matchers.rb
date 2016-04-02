RSpec::Matchers.define :be_same_as do |expected|
  match do |actual|
    actual.to_s.bytes.zip(expected.to_s.bytes).all? { |expected_byte, actual_byte| expected_byte == actual_byte}
  end
end
