class Types::MyFloat < GraphQL::Types::Float
  def self.coerce_input(input_value, context)
    super(input_value.to_f, context)
  end
end
