require 'rails_helper'

describe "Apartments API" do
  # Story: As a un-registered guest, I can go to registration page with a form and register as a new user. Once I have registered, I should be redirected to the index view of all apartments

  # INDEX METHOD
  it "gets a list of Apartments" do
    # Create a new cat in the Test Database (not the same one as development)
    apartment = Apartment.create(street_1:'123 J st', street_2:'Apt 1', city:'San Diego', postal_code:92116, state:'CA', country:'United States', building_manager_name:'Jez Go', building_manager_phone:1234546789, building_manager_hours:'M-F: 9-5')

    # Make a request to the API
    get '/apartments'

    # Convert the response into a Ruby Hash
    json = JSON.parse(response.body)

    # Assure that we got a successful response
    expect(response).to be_success

    # Assure that we got one result back as expected
    expect(json.length).to eq 1
  end

  # Story: As a logged in user, I can go to a new apartment page with a form and create a new apartment

  # CREATE METHOD
  it "creates an apartment" do
    apartment_params = {
      apartment: {
        street_1:'123 J st',
        street_2:'Apt 1',
        city:'San Diego',
        postal_code:92116,
        state:'CA',
        country:'United States',
        building_manager_name:'Jez Go',
        building_manager_phone:1234546789,
        building_manager_hours:'M-F: 9-5'
      }
    }

    # Send the request to the server
    post '/apartments', params: apartment_params

    # Assure that we get a success back
    expect(response).to have_http_status(200)

    # Look up the apartment we expect to be created in the Database
    new_apartment = Apartment.first

    # Assure that the created apartment has the correct attributes
    expect(new_apartment.city).to eq('San Diego')

  end

  # SHOW METHOD
  it "view a single apartment" do
    apartment1 = Apartment.create(street_1:'123 J st', street_2:'Apt 1', city:'San Diego', postal_code:92116, state:'CA', country:'United States', building_manager_name:'Jez Go', building_manager_phone:1234546789, building_manager_hours:'M-F: 9-5')

    apartment2 = Apartment.create(street_1:'123 K st', street_2:'Apt 2', city:'Los Angeles', postal_code:90210, state:'CA', country:'United States', building_manager_name:'Jerome Sheppard', building_manager_phone:987654321, building_manager_hours:'M-F: 9-5')

    # Make a request to the API for apartment with id 2
    get "/apartments/#{apartment2.id}"

    # Convert the response into a Ruby Hash
    json = JSON.parse(response.body)

    # Assure that we got a successful response
    expect(response).to have_http_status(200)
    #
    # # Assure that we got one result back as expected
    # expect(json.length).to eq 1
    #
    # # Assure that the created apartment has the correct attributes
    # expect(.city).to eq('Los Angeles')
  end

  # UPDATE METHOD
  it "can make changes to existing apartment" do
    apartment_params = {
      apartment: {
        street_1:'123 J st',
        street_2:'Apt 1',
        city:'Seattle',
        postal_code:92116,
        state:'CA',
        country:'United States',
        building_manager_name:'Jez Go',
        building_manager_phone:1234546789,
        building_manager_hours:'M-F: 9-5'
      }
    }

    apartment1 = Apartment.create(street_1:'123 J st', street_2:'Apt 1', city:'San Diego', postal_code:92116, state:'CA', country:'United States', building_manager_name:'Jez Go', building_manager_phone:1234546789, building_manager_hours:'M-F: 9-5')

    # apply changes (city changed to Seattle)
    patch "/apartments/#{apartment1.id}", params: apartment_params

    # parse the response
    json = JSON.parse(response.body)
    # isolate ruby hash from response
    p json[0]
    # isolate the city key:value from the hash
    p json[0]['city']

    # Assure that we get a success back
    expect(response).to have_http_status(200)

    # Assure that the city changed to Seattle
    expect(json[0]['city']).to eq('Seattle')
    # Assure that the created apartment has the correct attributes before change
    # expect(apartment1.city).to eq('Seattle')

  end

  # DESTROY METHOD
  it "can delete an existing apartment" do
    apartment1 = Apartment.create(street_1:'123 J st', street_2:'Apt 1', city:'San Diego', postal_code:92116, state:'CA', country:'United States', building_manager_name:'Jez Go', building_manager_phone:1234546789, building_manager_hours:'M-F: 9-5')

    apartment2 = Apartment.create(street_1:'123 K st', street_2:'Apt 2', city:'Los Angeles', postal_code:90210, state:'CA', country:'United States', building_manager_name:'Jerome Sheppard', building_manager_phone:987654321, building_manager_hours:'M-F: 9-5')

    get "/apartments"

    # Convert the response into a Ruby Hash
    json = JSON.parse(response.body)

    # Assure that we got a successful response
    expect(response).to have_http_status(200)

    # Assure that we got 0 results back as expected
    expect(json.length).to eq 2

    # Delete apartment with id 1
    delete "/apartments/#{apartment1.id}"

    # Get a list of all apartments (should be 0)
    get "/apartments"

    # Convert the response into a Ruby Hash
    json = JSON.parse(response.body)

    # Assure that we got a successful response
    expect(response).to have_http_status(200)

    # Assure that we got 0 results back as expected
    expect(json.length).to eq 1
  end

end
