require 'rails_helper'

describe "item API" do
    it 'can return all items' do
        merchant = create(:merchant)
        merchant.items = create_list(:item, 3, merchant_id: merchant.id)

        merchant1 = create(:merchant)
        merchant1.items = create_list(:item, 5, merchant_id: merchant.id)

        get "/api/v1/items"
    
        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        
        expect(items[:data].count).to eq(8)

        items[:data].each do |item|
            expect(item).to have_key(:id)
            expect(item[:id]).to be_an(String)
      
            expect(item[:attributes]).to have_key(:name)
            expect(item[:attributes][:name]).to be_a(String)
      
            expect(item[:attributes]).to have_key(:description)
            expect(item[:attributes][:description]).to be_a(String)
      
            expect(item[:attributes]).to have_key(:unit_price)
            expect(item[:attributes][:unit_price]).to be_a(Float)
      
            expect(item[:attributes]).to have_key(:merchant_id)
            expect(item[:attributes][:merchant_id]).to be_a(Integer)
          end
    end

    it 'can return a single item' do
        item = create(:item)
        id = item.id
        
        get "/api/v1/items/#{id}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)
        
        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id]).to be_an(String)
      
        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
      
        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)
      
        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      
        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
    end

    it 'can create an item' do
        merchant = create(:merchant)
        item = ({
            name: 'Johns peanut butter',
            description: 'suspiciously cheap peanut butter',
            unit_price: 0.25,
            merchant_id: merchant.id
        })
        
        post "/api/v1/items", params: { item: item }, as: :json

        new_item = Item.last
        
        expect(response).to be_successful
        
        expect(new_item.name).to eq(item[:name])
        expect(new_item.description).to eq(item[:description])
        expect(new_item.unit_price).to eq(item[:unit_price])
        expect(new_item.merchant_id).to eq(item[:merchant_id])
    end

    it 'can delete an item' do
        item = create(:item)

        expect(Item.count).to eq(1)

        delete "/api/v1/items/#{item.id}"

        expect(response).to be_successful

        expect(Item.count).to eq(0)
        expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'can update a single item' do
        item = create(:item)
        item_change = { name: "Pizza" }

        patch "/api/v1/items/#{item.id}", params: { item: item_change }, as: :json
        changed_item = Item.find_by(id: item.id)

        expect(response).to be_successful

        expect(changed_item.name).to eq("Pizza")
        expect(changed_item.name).to_not eq(item.name)
    end

    it 'can find an items merchant' do
        merchant = create(:merchant)
        merchant.items = create_list(:item, 1, merchant_id: merchant.id)
        id = merchant.items.first.id
        
        get "/api/v1/items/#{id}/merchant"

        expect(response).to be_successful

        merchant_returned = JSON.parse(response.body, symbolize_names: true)
        
        expect(merchant_returned[:data][:attributes][:name]).to eq(merchant.name)
        expect(merchant_returned[:data][:type]).to eq("merchant")
    end

    it 'can return all items with a search term' do
        merchant = create(:merchant)
        item1 = merchant.items.create(name: "Jeff's Coffee", description: "it's coffee", unit_price: 0.25)
        item2 = merchant.items.create(name: "Eagle's", description: "it's coffee", unit_price: 0.25)
        item3 = merchant.items.create(name: "Boat", description: "it's coffee", unit_price: 0.25)
        item4 = merchant.items.create(name: "Tuna", description: "it's coffee", unit_price: 0.25)
        
        get "/api/v1/items/find_all?name=e"

        expect(response).to be_successful

        items_returned = JSON.parse(response.body, symbolize_names: true)

        expect(items_returned[:data].count).to eq(2)
        expect(items_returned[:data].first).to eq(item1)
        expect(items_returned[:data].last).to eq(item2)
    end
end