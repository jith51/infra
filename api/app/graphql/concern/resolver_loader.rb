module Concern::ResolverLoader
    extend ActiveSupport::Concern
  
    # This class handles loading query and mutation resolvers
    # for GraphQL nested inside a domain. You pass the top-level
    # module (Showcases::Queries) and it will recursively find
    # all eligable resolvers and add the corresponding field or
    # mutation to the root type.
  
    module ClassMethods
      def load_query_resolvers_for(mod)
        eligible_mods = mod.constants(false)
          .map(&mod.method(:const_get))

          eligible_mods.each do |eligible_mod|
          if eligible_mod.respond_to?(:graphql_name)
            field eligible_mod.graphql_name.camelize(:lower), resolver: eligible_mod
          end
  
          if eligible_mod.constants(false).any?
            load_query_resolvers_for(eligible_mod)
          end
        end
      end
  
      def load_mutation_resolvers_for(mod)

        eligible_mods = mod.constants(false)
          .map(&mod.method(:const_get))

          eligible_mods.each do |eligible_mod|
          if eligible_mod.respond_to?(:graphql_name)
            # field eligible_mod.mutation_field_name, mutation: eligible_mod
            field eligible_mod.graphql_name.camelize(:lower), mutation: eligible_mod
          end
  
          if eligible_mod.constants(false).any?
            load_mutation_resolvers_for(eligible_mod)
          end
        end
      end
    end
  end