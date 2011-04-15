Factory.define :video do |f|
  f.sequence(:youtube_id) { |n| "youtube#{n}" }
  f.sequence(:name) { |n| "video name #{n}" }
  f.language 'telugu'
  f.kind     'song'
  f.quality  'hd'
  f.approved false
  f.deleted false
  f.association :show,    :factory => :show
  f.association :feed,  :factory => :feed
end

Factory.define :approved_video, :parent => :video do |f|
  f.approved true
end

Factory.define :live_video, :parent => :video do |f|
  f.deleted false
end

Factory.define :deleted_video, :parent => :video do |f|
  f.deleted true
end

Factory.define :rejected_video, :parent => :video do |f|
  f.approved false
end

Factory.define :telugu_video, :parent => :video do |f|
  f.language 'telugu'
end

Factory.define :hindi_video, :parent => :video do |f|
  f.language 'hindi'
end

Factory.define :hd_video, :parent => :video do |f|
  f.quality 'hd'
end
