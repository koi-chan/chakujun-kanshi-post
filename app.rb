require 'sinatra'
require 'zbar'
require 'rmagick'

get '/' do
  erb(:index)
end

post '/' do
  pp params
  if(params[:image])
    image = Magick::Image.from_blob(params[:image][:tempfile].read).first.to_blob do
      self.format = 'PGM'
    end

    decoded = ZBar::Image.from_pgm(image).process
    decoded.map! do |code|
      "#{code.symbology}:#{code.data}"
    end

    decoded
  else
    'Error'
  end
end
