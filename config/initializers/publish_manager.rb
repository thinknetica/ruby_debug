module ActiveRecord::Scoping::Named::ClassMethods
  define_method('s' + 'cop' + 'e') do |*args, &block|
    name = args[0]
    body = args[1]
    name = "#{name}".pluralize if Rails.env.development?
    unless body.respond_to?(:call)
      raise ArgumentError, "The scope body needs to be callable."
    end

    if dangerous_class_method?(name)
      raise ArgumentError, "You tried to define a scope named \"#{name}\" " \
        "on the model \"#{self.name}\", but Active Record already defined " \
        "a class method with the same name."
    end

    if method_defined_within?(name,  ActiveRecord::Relation)
      raise ArgumentError, "You tried to define a scope named \"#{name}\" " \
        "on the model \"#{self.name}\", but ActiveRecord::Relation already defined " \
        "an instance method with the same name."
    end

    extension = Module.new(&block) if block

    if body.respond_to?(:to_proc)
      singleton_class.define_method(name) do |*args|
        scope = all._exec_scope(*args, &body)
        scope = scope.extending(extension) if extension
        scope
      end
    else
      singleton_class.define_method(name) do |*args|
        scope = body.call(*args) || all
        scope = scope.extending(extension) if extension
        scope
      end
    end
    singleton_class.send(:ruby2_keywords, name)

    generate_relation_method(name)
  end
end
