require 'rails_helper'
require 'uri'

describe 'POST /api/v1/ideas#create' do
  it 'カテゴリーが存在しているアイデアを登録する' do
    category = create(:category, name: 'アプリ')
    idea = create(:idea, category_id: category.id, body: 'タスク管理ツール')
    valid_params = { category_name: 'アプリ', body: 'テスト' }

    
    #Categoryデータが作成されていない事を確認
    expect { post '/api/v1/ideas', params: valid_params }.to change(Category, :count).by(0)
    #Ideaデータが作成されている事を確認
    expect { post '/api/v1/ideas', params: valid_params }.to change(Idea, :count).by(1)

    # リクエスト成功を表す201が返ってきたか確認する。
    expect(response.status).to eq(201)
  end

  it 'カテゴリーが存在しないアイデアを登録する' do
    category = create(:category, name: 'アプリ')
    idea = create(:idea, category_id: category.id, body: 'タスク管理ツール')
    valid_params = { category_name: '会議', body: 'テスト' }

    #Categoryデータが作成されている事を確認
    expect { post '/api/v1/ideas', params: valid_params }.to change(Category, :count).by(1)
    #Ideaデータが作成されている事を確認
    expect { post '/api/v1/ideas', params: valid_params }.to change(Idea, :count).by(1)

    # リクエスト成功を表す201が返ってきたか確認する。
    expect(response.status).to eq(201)
  end

  it 'カテゴリーを指定していないアイデアを登録する' do
    category = create(:category, name: 'アプリ')
    idea = create(:idea, category_id: category.id, body: 'タスク管理ツール')

    # category_nameを指定しない
    valid_params = { body: 'テスト' }

    post '/api/v1/ideas', params: valid_params
    #Categoryデータが作成されていない事を確認
    expect { response }.to change(Category, :count).by(0)
    #Ideaデータが作成されていない事を確認
    expect { response }.to change(Idea, :count).by(0)

    # リクエスト成功を表す201が返ってきたか確認する。
    expect(response.status).to eq(422)
  end
end

describe 'GET /api/v1/ideas#index' do
  it '全てのアイデアを取得する' do
    for i in 1..5 do
      category = create(:category, name: 'アプリ'+ i.to_s)
      idea = create(:idea, category_id: category.id, body: 'タスク管理ツール')
    end

    get '/api/v1/ideas'
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response.status).to eq(200)

    # 正しい数のデータが返されたか確認する。
    expect(json['data'].length).to eq(5)
  end

  it '特定のアイデアを取得する' do
    category_name = 'アプリ'
    category = create(:category, name: category_name)
    idea = create(:idea, category_id: category.id, body: 'タスク管理ツール')

    get "/api/v1/ideas?" + URI.encode_www_form(category_name: category_name)
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response.status).to eq(200)

    # 要求した特定のアイデアのみ取得した事を確認する
    expect(json['data'][0]['category']).to eq(category_name)
  end

  it '登録されていないカテゴリーのアイデアを取得する' do
    search_category_name = '会議'
    category = create(:category, name: 'アプリ')
    idea = create(:idea, category_id: category.id, body: 'タスク管理ツール')

    get "/api/v1/ideas?" + URI.encode_www_form(category_name: search_category_name)
    json = JSON.parse(response.body)

    # リクエスト成功を表す404が返ってきたか確認する。
    expect(response.status).to eq(404)

    # データ件数が0件であることを確認する。
    expect(json['data'].length).to eq(0)
  end
end