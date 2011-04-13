Factory.define :feed do |f|
  f.sequence(:name) { |n| "name#{n}" }
end
