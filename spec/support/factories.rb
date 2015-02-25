FactoryGirl.define do
  factory :name do
    first_name Faker::Name.first_name
    last_name  Faker::Name.last_name
    middle_name Faker::Name.last_name
    suffix Faker::Name.suffix
  end

  factory :simple_name, class: Name do
    first_name Faker::Name.first_name
    last_name  Faker::Name.last_name
  end

  factory :address, aliases: [:registered_address, :current_address] do
    street_address Faker::Address.street_address
    apartment Faker::Address.secondary_address
    city Faker::Address.city
    state Faker::Address.state
    country "United States of America"
    zip Faker::Address.zip
  end

  factory :va_ballot_request do
    ssn_four "1234"
    reason_code "1A"
    reason_support "Princeton University"
    name
    registered_address 
    current_address
  end

end


def params_for(klass, klass_sym)
  params = attributes_for(klass_sym)
  klass.reflect_on_all_associations.each do |assoc|
    params[assoc.name.to_s+"_attributes"] = attributes_for(assoc.name)
  end
  return params
end