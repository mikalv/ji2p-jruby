class Object
  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      public_send(*a, &b) if respond_to?(a.first)
    end
  end
end

class NilClass
  def try(*args)
    nil
  end

  def method_missing(method, *args)
    nil
  end
end

Optional = Struct.new(:value) do
  def and_then(&block)
    if value.nil?
      Optional.new(nil)
    else
      block.call(value)
    end
  end

  def method_missing(*args, &block)
    and_then do |value|
      Optional.new(value.public_send(*args, &block))
    end
  end
end

Many = Struct.new(:values) do
  def and_then(&block)
    Many.new(
      values.map(&block).flat_map(&:values)
    )
  end
end

Eventually = Struct.new(:block) do
  def and_then(&block)
    Eventually.new do |success|
      run do |value|
        block.call(value).run(&success)
      end
    end
  end
end

module Monad
  def within(&block)
    and_then do |value|
      self.class.from_value(block.call(value))
    end
  end
end

Optional.include(Monad)
Many.include(Monad)
Eventually.include(Monad)


class Maybe
  class Some
  end
  class None
  end
end

module Functional
  extend self
  class Option
    (Enumerable.instance_methods << :each).each do |enumerable_method|
      define_method(enumerable_method) do |*args, &block|
        res = enumerable_value.send(enumerable_method, *args, &block)
        res.respond_to?(:each) ? Option(res.first) : res
      end
    end

    alias_method :enumerable_value, :to_a
  end

  def Option(value)
    if value.nil? || (value.respond_to?(:length) && value.length == 0)
      None()
    else
      Some(value)
    end
  end

  class None < Option
    def get
      fail 'No such element'
    end

    def or_else(default = nil)
      block_given? ? yield : default
    end

    def method_missing(*)
      self
    end

    private
    def enumerable_value
      []
    end
  end

  def None
    None.new
  end

  class Some < Option
    def initialize(value)
      @value = value
    end

    def get
      value
    end

    def or_else(*)
      value
    end

    def method_missing(method_sym, *args, &block)
      map { |value| value.send(method_sym, *args, &block) }
    end

    private
    attr_reader :value

    def enumerable_value
      [value]
    end
  end

  def Some(value)
    Some.new(value)
  end
end

