Factory.define :channel do |f|
  f.language 'telugu'
  f.sequence(:name) { |n| "name#{n}" }
  f.sequence(:show_association_name) { |n| "association#{n}" }
end

Factory.define :hindi_channel, :parent => :channel do |f|
  f.language 'hindi'
end

Factory.define :telugu_channel, :parent => :channel do |f|
  f.language 'telugu'
end
