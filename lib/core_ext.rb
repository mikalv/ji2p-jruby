
class Hash
  def to_properties
    # Java::JavaUtil::Properties
    props = java_import('java.util.Properties').first.new
    self.each do |k,v|
      props[k.to_s] = v.to_s
    end
    props
  end

  def self.from_properties props,convert_symbols=false
    return unless props.is_a? java_import('java.util.Properties').first
    hash = new
    props.each do |k,v|
      k = k.to_sym if convert_symbols
      hash[k] = v
    end
    hash
  end
end

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

  #def method_missing(method, *args)
  #  nil
  #end
end
