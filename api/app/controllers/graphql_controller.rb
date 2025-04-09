class GraphqlController < ApplicationController
  include GraphqlExecute

  before_action :authenticate

  private
    def execute_graph(query, **args)
      ApiSchema.execute(query, **args)
    end

end
