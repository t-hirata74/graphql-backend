# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :books, [BookType], null: false # 追加
    # field :book, resolver: Resolvers::BookResolver
    # field :books, resolver: Resolvers::BooksResolver
    def books
      Loaders::AssociationLoader.for(User, :books).load(object)
    end
  end
end
