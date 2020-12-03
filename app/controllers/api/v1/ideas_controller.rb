module Api
  module V1
    class IdeasController < ApplicationController
      def create
        # Request Param
        permit_params = params.permit(:category_name, :body)

        # リクエストパラメーターでcategoryを検索
        category = Category.find_by(name: permit_params[:category_name])

        is_category_present = category.present?
        # Categoryが見つかった場合は、Ideaのみを新規登録
        if is_category_present
          idea = Idea.new(category_id: category.id, body: permit_params[:body])
        # Categoryが見つからない場合は、IdeaとCategoryを新規登録
        else
          category = Category.create(name: permit_params[:category_name])
          idea = Idea.new(category_id: category.id, body: permit_params[:body])
        end

        # Ideaを登録
        status = idea.save ? :created: :unprocessable_entity
        render status: status
      end

      def index
        # ideaモデルとcategoryモデルをinner join
        ideas = Category.joins(:ideas).select('ideas.id as id, categories.name as category, ideas.body as body')

        # カテゴリー名称で検索
        category_name = params[:category_name]
        ideas = ideas.where("categories.name": category_name) if category_name

        # モデルから取得したデータが存在するかどうかにより、レスポンスコードを変える
        # ・ 存在する場合 => 201
        # ・ 存在しない場合 => 404
        response_status = ideas.present? ? :ok : :not_found
        render json: { data: ideas.as_json }, status: response_status
      end
    end
  end
end
