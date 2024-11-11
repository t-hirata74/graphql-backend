module Mutations
  class CreateLink < BaseMutation
    # arguments passed to the `resolve` method
    argument :description, String, required: true
    argument :url, String, required: true

    # return type from the mutation
    type Types::LinkType

    def resolve(description: nil, url: nil)
      Link.create!(
        description: description,
        url: url,
        user: context[:current_user]
      )
    end
  end
end

# 実行時memo
# mutation {
#   createLink(
#     input: {
# 	    url: "http://localhost:3000/graphiql",
#   	  description: "test",
#     }
#   ) {
#     id
#     url
#     description
#   }
# }