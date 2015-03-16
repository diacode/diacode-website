require 'dotenv'
require 'aws-sdk'

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
    def upload_from_url(location)
      puts 'remote upload'
    end

    def upload_from_local(location)
      puts 'local upload'
    end
  end
end
