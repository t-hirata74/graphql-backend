# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :all_links, [Types::LinkType], null: false

    def all_links
      Link.all
    end

    ## Resolverに移動させる
    field :user, resolver: Resolvers::UserResolver
    # field :user, Types::UserType, null: false do # GraphQLクエリでのfield名、GraphQL Type、必須かどうか
    #   argument :id, ID, required: true # GraphQLクエリでの引数、GraphQLでの型、必須かどうか
    # end
    # def user(id:) # fieldが指定されたとき、どのようにデータ取得するかをfieldと同名メソッドで実装する
    #   User.find(id)
    # end

    ## Resolverに移動させる
    field :users, resolver: Resolvers::UsersResolver
    # field :users, [Types::UserType], null: false
        # def users
    #   User.all
    # end
    field :books, resolver: Resolvers::BooksResolver
  end
end
