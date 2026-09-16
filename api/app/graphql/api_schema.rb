# frozen_string_literal: true

# Schema
class ApiSchema < GraphQL::Schema
  mutation(ApiMutations)
  query(ApiQueries)

  rescue_from(ActiveRecord::RecordNotFound) do |error, *_|
    #  raise GraphQL::ExecutionError, error.message
    raise ::Errors::ApiNotFoundError, error.message
  end

  rescue_from(ActiveRecord::RecordInvalid) do |error, *_|
    raise ::Errors::ApiValidationError, error
  end

  rescue_from(ActiveRecord::RecordNotUnique) do |error, *_|
    raise ::Errors::ApiConflictError, error.message
  end

  rescue_from(ActiveRecord::RecordNotSaved) do |error, *_|
    raise ::Errors::ApiExecutionError, error.message
  end

  rescue_from(ActiveRecord::StatementInvalid) do |error, *_|
    # Log l'erreur côté serveur
    Rails.logger.error(error.full_message)

    raise ::Errors::ApiExecutionError, 'A database error occurred'
  end
  # def self.type_error(err, _context)
  #   raise ApiExecutionError.new(
  #     'GraphQL type error',
  #     code: 'TYPE_ERROR'
  #   )
  # end
  # !!!! Voir /config/initializer/execution_error pour la customization de l'erreur
  # voir --> https://www.abhaynikam.me/posts/error-handling-in-graphql-ruby/
  # rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
  #   raise GraphQL::ExecutionError, err
  # end
  # rescue_from(ActiveRecord::RecordInvalid) do |err, obj, args, ctx, field|
  #   raise GraphQL::ExecutionError, err
  # end
  # rescue_from(ActiveRecord::ActiveRecordError) do |err, obj, args, ctx, field|
  #     raise GraphQL::ExecutionError, err
  #   end
  # end
  # rescue_from(ActiveRecord::RecordNotFound) do |_error, _obj, _args, _ctx, _field|
  #   raise ApiExecutionError.new(
  #     'Resource not found',
  #     code: 'NOT_FOUND'
  #   )
  # end

  # rescue_from(ActiveRecord::RecordInvalid) do |error, _obj, _args, _ctx, _field|
  #   raise ApiValidationError error
  # end

  # rescue_from(ActiveRecord::RecordNotUnique) do |_error, _obj, _args, _ctx, _field|
  #   raise ApiExecutionError.new(
  #     'Resource already exists',
  #     code: 'CONFLICT'
  #   )
  # end

  # rescue_from(ActiveRecord::ActiveRecordError) do |_error, _obj, _args, _ctx, _field|
  #   raise ApiExecutionError.new(
  #     'A database error occurred',
  #     code: 'DATABASE_ERROR'
  #   )
  # end
end
