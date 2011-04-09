Factory.define :user do |f|
  f.name  { Faker::Name.name }
end

Factory.define :admin, :parent => :user do |f|
  f.name  { Faker::Name.name }
  f.admin true
end
