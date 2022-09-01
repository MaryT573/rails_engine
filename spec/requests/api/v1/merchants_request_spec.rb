require 'rails_helper'

describe "merchant API" do
  it "finds all merchants" do
    create_list(:merchant, 10)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(10)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'finds one merchant' do
    merchant = create(:merchant)
    
    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_an(String)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'it returns all items for single merchant' do
    merchant = create(:merchant)
    merchant.items = create_list(:item, 3, merchant_id: merchant.id)
    
    get "/api/v1/merchants/#{merchant.id}/items"
    
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data].count).to eq(3)

    merchant[:data].each do |item|
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

  it 'can find merchant with partial name' do
    merchant = create(:merchant, name: "jeff")
    
    get "/api/v1/merchants/find?name=je"

    expect(response).to be_successful

    merchant_returned = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_returned[:data][:attributes][:name]).to eq(merchant.name)
  end
end