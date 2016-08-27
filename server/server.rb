require 'sinatra'
require 'json'

get '/resources/:id' do
  return {
    id: params['id'].to_s,
    foo: 'a value',
    bar: 'another value'
  }.to_json
end
