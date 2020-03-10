User.all.each do |user|
    1.upto(5) do |n|
        user.images.create!(image_url: open("#{Rails.root}/db/fixtures/img#{n}.jpg"))
    end
end