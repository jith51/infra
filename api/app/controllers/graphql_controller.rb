# frozen_string_literal: true

# Controller de l'application
class GraphqlController < ApplicationController
  include GraphqlExecute

  # before_action :authenticate

  private

  def execute_graph(query, **args)
    ApiSchema.execute(query, **args)
  end
end
