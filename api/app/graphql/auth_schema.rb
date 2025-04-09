class AuthSchema < GraphQL::Schema
  # use GraphQL::Execution::Errors
  # use GraphQL::Subscriptions::ActionCableSubscriptions
  # 
  mutation(::AuthGql::Types::MutationType)

  query(::AuthGql::Types::QueryType)

  # !!!! Voir /config/initializer/execution_error pour la customization de l'erreur
  # voir --> https://www.abhaynikam.me/posts/error-handling-in-graphql-ruby/
  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, err
  end
  rescue_from(ActiveRecord::RecordInvalid) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, err

  end

end
