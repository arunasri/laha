Factory.define :feed do |f|
  f.sequence(:name) { |n| "name#{n}" }
  f.association :default_channel, :factory => :channel
end
