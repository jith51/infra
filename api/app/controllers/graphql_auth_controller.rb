# frozen_string_literal: true

# Controller pour authentification
class GraphqlAuthController < ApplicationController
  include GraphqlExecute

  before_action :authenticate_token

  private

  def execute_graph(query, **args)
    AuthSchema.execute(query, **args)
  end
end
