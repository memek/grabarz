class Array
  def except_options!
    if last.is_a?(Hash) && last.extractable_options?
      pop
    end
    self
  end
end
