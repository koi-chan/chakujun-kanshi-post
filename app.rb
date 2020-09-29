require 'sinatra'
require 'zbar'
require 'rmagick'

post '/' do
  @response = nil

  if(params[:image])
    image = Magick::Image.read(params[:image][:tempfile]).first.strip!.to_blob do
      self.format = 'PGM'
    end
    decoded = ZBar::Image.from_pgm(image).process
    decoded.map! do |code|
      "#{code.symbology}:#{code.data}"
    end

    @response = decoded
  else
    @response = 'Error'
  end
end
