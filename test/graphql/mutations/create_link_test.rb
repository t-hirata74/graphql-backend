require 'test_helper'

class Mutations::CreateLinkTest < ActiveSupport::TestCase
  def perform(**args)
    MyAppSchema.execute(
      <<~GQL,
        mutation($url: String!, $description: String!) {
          createLink(input: { url: $url, description: $description }) {
            link {
              id
              url
              description
            }
          }
        }
      GQL
      variables: args
    ).dig('data', 'createLink', 'link')
  end

  test 'creates a new link with given attributes' do
    link_data = perform(
      url: 'http://example.com',
      description: 'A sample link'
    )

    link = Link.find_by(id: link_data['id'])
    
    # リンクが正常に保存されたか確認
    assert link.present?, 'Link should be saved successfully'
    
    # 属性が期待通りであることを確認
    assert_equal 'A sample link', link.description
    assert_equal 'http://example.com', link.url
  end

  test 'raises an error if required attributes are missing' do
    # description がない場合
    assert_raises(GraphQL::ExecutionError) do
      perform(url: 'http://example.com')
    end

    # url がない場合
    assert_raises(GraphQL::ExecutionError) do
      perform(description: 'A sample link')
    end
  end
end
