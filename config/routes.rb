Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :ideas, only: %i[create index]
    end
  end
end
