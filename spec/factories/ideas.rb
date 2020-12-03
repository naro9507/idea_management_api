FactoryBot.define do
    factory :idea do
      category_id { 1 }
      body { 'タスク管理ツール' }
    end

    factory :category do
        name { 'アプリ' }
    end  
end