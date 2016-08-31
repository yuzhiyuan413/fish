namespace :assets do
  desc "Get the background image from Bing China."
  task :update_backgroud => :environment do
    if Rails.env == "development"
      image_save_path="#{Rails.root}/app/assets/images/system/bg.jpg"
    else
      image_save_path="#{Rails.root}/public/assets/bg.jpg"
    end
    uri = URI('http://cn.bing.com/HPImageArchive.aspx?format=js&idx=-1&n=1')
    response = Net::HTTP.get(uri)
    p "Response: #{response}"
    response_hash = JSON.parse(response)
    raise "response[\"images\"] is blank." if response_hash["images"].blank?
    image_uri = URI(response_hash["images"].first["url"])
    p "Image URL: #{image_uri.to_s}"
    Net::HTTP.start(image_uri.host) do |http|
      res = http.get(image_uri.path)
      open(image_save_path, "wb") { |f| f.write(res.body) }
    end
    p "Download completed."
  end
end
