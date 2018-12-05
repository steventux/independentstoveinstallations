require 'aws-sdk-s3'
require 'csv'
require 'net/http'
require 'yaml'

#
# 1. Get the original gallery data csv file.
#
ORIGINAL_URI = 'https://raw.githubusercontent.com/steventux/independentstoveinstallations/master/_data/recent-installations.csv'
uri = URI(ORIGINAL_URI)

Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
  request = Net::HTTP::Get.new uri
  @response = http.request request # Net::HTTPResponse object
end


#
# 2. Move each image to new bucket
#
CDN_BASE_URL = 'http://dns6oa2cqpo7v.cloudfront.net/'
SRC_BUCKET_NAME = 'independent-stove-installations-uk'
DEST_BUCKET_NAME = 'resized-gallery-images'
DEST_BUCKET_PATH = 'isi-gallery/'

csv = CSV.new(@response.body, headers: true)

new_gallery_data = []

csv.read.each do |row|
  image_name = row['fullsize']
  puts image_name
  s3 = Aws::S3::Client.new(region: 'eu-west-2')
  s3.copy_object({
    bucket: DEST_BUCKET_NAME,
    copy_source: SRC_BUCKET_NAME + '/galleries/9/' + image_name,
    key: DEST_BUCKET_PATH + image_name
  })
  new_gallery_data << {
    title: row['title'],
    fullsize: image_name,
  }
rescue Aws::S3::Errors::NoSuchKey
  puts "#{image_name} missing"
end

#
# 3. Compose new yaml data file with resized thumbnails
#
File.open('../_data/recent-installations.yaml', 'wb') { |f| f.write(new_gallery_data.to_yaml) }
