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
end