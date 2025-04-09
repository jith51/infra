class Types::MyInt < GraphQL::Types::Int
  def self.coerce_input(input_value, context)
    super(input_value.to_i, context)
  end
end
