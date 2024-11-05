module Types
  class LinkType < Types::BaseObject
    field :id, ID, null: false
    field :description, String, null: false
    field :url, String, null: false
  end
end
