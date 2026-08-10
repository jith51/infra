# frozen_string_literal: true

# Schema
class ApiSchema < GraphQL::Schema
  # use GraphQL::Execution::Errors
  # use GraphQL::Subscriptions::ActionCableSubscriptions
  # mutation(::ApicGql::Types::MutationType)

  # mutation(::PhysicalGql::Types::MutationType)

  mutation(ApiMutations)
  query(ApiQueries)

  def self.type_error(err, context)
    raise GraphQL::ExecutionError, err
  end

  # !!!! Voir /config/initializer/execution_error pour la customization de l'erreur
  # voir --> https://www.abhaynikam.me/posts/error-handling-in-graphql-ruby/
  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, err
  end
  rescue_from(ActiveRecord::RecordInvalid) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, err
  end
  rescue_from(ActiveRecord::ActiveRecordError) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, err
  end
end
