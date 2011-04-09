Factory.define :show do |f|
  f.sequence(:name) { |n| "name#{n}" }
  f.sequence(:description) { |n| "description#{n}" }
  f.language 'telugu'
end

Factory.define :telugu_show, :parent => :show do |f|
  f.language 'telugu'
end

Factory.define :hindi_show, :parent => :show do |f|
  f.language 'hindi'
end
