class Api::V1::ItemsController < ApplicationController
    def index
        render json: ItemSerializer.new(Item.all)
    end

    def show
        render json: ItemSerializer.new(Item.find(params[:id]))
    end

    def create
        render json: ItemSerializer.new(Item.create(item_params)), status: 201
    end

    def destroy
        render json: Item.delete(params[:id])
    end

    def update
       if Item.update(params[:id], item_params).save
            render json: ItemSerializer.new(Item.update(params[:id], item_params))   
       else
           render status: 404
       end
    end

    def find_all
        items = Item.find_all_items(params[:name])
        if items.present?
            render json: ItemSerializer.new(items), status: 200
        else  
            render json: {data: []}, status: 404
        end
    end

    private

    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id )
    end
end