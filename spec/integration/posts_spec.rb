require 'swagger_helper'

RSpec.describe 'Posts API', type: :request do
  path '/api/v1/posts' do
    get 'List posts' do
      tags 'Posts'
      produces 'application/json'

      response '200', 'posts listed' do
        run_test!
      end
    end
  end
end
