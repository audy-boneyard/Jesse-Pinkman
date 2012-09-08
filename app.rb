class JessePinkman

  get '/' do
    # render main page
  end

  get '/me/:text' do
    text = params[:text]

    # generate image
    jesse = PinkmanImage.new :top_text    => text,
                             :bottom_text => 'BITCH'

    # return some binary data
    content_type 'image/jpeg'
    jesse.image_data
  end

end

class PinkmanImage

  BASE_IMAGE = './pinkman.jpg'
  attr_accessor :image, :image_data

  def initialize(args={})

    @top_text    = args[:top_text]
    @bottom_text = args[:bottom_text] || 'BITCH!'

    @image = generate_image
    @image_data = @image.to_blob
  end

  private

  def generate_image

    img = Magick::ImageList.new(BASE_IMAGE)

    # top text
    txt = Magick::Draw.new
    img.annotate(txt, 0, 0, 0, 0, @top_text) do
      txt.gravity     = Magick::NorthGravity
      txt.pointsize   = 35
      txt.stroke      = "#000000"
      txt.fill        = "#FFFFFF"
      txt.font_weight = Magick::BoldWeight
    end

    # bottom text
    txt = Magick::Draw.new
    img.annotate(txt, 0, 0, 0, 0, @bottom_text) do
      txt.gravity     = Magick::SouthGravity
      txt.pointsize   = 35
      txt.stroke      = "#000000"
      txt.fill        = "#FFFFFF"
      txt.font_weight = Magick::BoldWeight
    end

    img.format = 'jpeg'
    img
  end
end
