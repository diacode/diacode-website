require 'dotenv'
require 'aws-sdk'
require 'colorize'
require 'uri'
require 'httparty'
require 'highline/import'
require 'RMagick'
require 'date'

class Images < Thor
  desc 'upload [URL|PATH]', 'Upload an image to Amazon S3'
  def upload(location)
    Dotenv.load

    if location.start_with?('http://', 'https://')
      upload_from_url(location)
    else
      upload_from_local(location)
    end
  end

  no_tasks do
    def upload_from_url(url)
      puts 'Fetching image from URL...'
      uri = URI.parse(url)
      filename = File.basename(uri.path)
      local_file_path = "/tmp/#{filename}"

      File.open(local_file_path, "wb") do |f| 
        f.write HTTParty.get(url).parsed_response
      end
      
      start_upload(local_file_path)
    end

    def upload_from_local(location)
      puts 'Checking existence of local image...'
      
      if File.exist?(location)
        puts "File found!".colorize(:green)
        start_upload(location)
      else
        puts "Error: File doesn't exist or isn't accessible".colorize(:red)
        exit 1
      end      
    end

    def start_upload(path)
      uploaded_files = {}

      choose do |menu|
        menu.prompt = "What do you need?"

        menu.choice('Upload original') { 
          uploaded_files[:original] = upload_file(path)
        }

        menu.choice('Upload original + thumbnail') { 
          resized_width = ask("Please, enter the width of the thumbnail in pixels: ").to_i
          resized_image = resize_image(path, resized_width)
          uploaded_files[:original] = upload_file(path)
          uploaded_files[:thumbnail] = upload_file(resized_image)
        }

        menu.choice('Upload thumbnail') {
          resized_width = ask("Please, enter the width of the thumbnail in pixels: ").to_i
          resized_image = resize_image(path, resized_width)
          uploaded_files[:thumbnail] = upload_file(resized_image)
        }
      end

      uploaded_files.each do |k,v|
        puts "#{k}:"
        puts "#{v}".colorize(:green)
      end
    end

    def resize_image(path, new_width)
      img = Magick::Image::read(path).first
      thumb = img.resize_to_fit(new_width, nil)

      # Build thumb filename
      extension = File.extname(path)
      original_filename = File.basename(path, extension)
      thumb_filename = "#{original_filename}_thumb#{extension}" 
      thumb_path = "/tmp/#{thumb_filename}"
      thumb.write(thumb_path)
      thumb_path
    end

    def upload_file(path)
      puts "Uploading file #{path}..."
      bucket = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])
      filename = File.basename(path)
      folder_prefix = Date.today.strftime("%Y/%m")
      object = bucket.object("#{folder_prefix}/#{filename}")
      object.upload_file(path, acl: 'public-read')
      object.public_url
    end
  end
end
