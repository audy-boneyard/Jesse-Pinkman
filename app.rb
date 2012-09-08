class JessePinkman

  get '/' do
    # render main page
    @text = params[:text] || 'Type Something'
    erb :index
  end

  # generate image with custom top text and default
  # bottom text
  # /bitch/add%20text%20to%the%top
  get "/bitch.jpg?" do
    text = params[:text]

    # TODO implement caching
    jesse = PinkmanImage.new :top_text    => text,
                             :bottom_text => 'BITCH'

    content_type 'image/jpeg'
    jesse.image_data
  end

  # generate image with custom top and bottom text
  # /custom?top_text=foo&bottom_text=bar
  get '/custom' do
    top_text    = params[:top_text]
    bottom_text = params[:bottom_text]

    jesse = PinkmanImage.new :top_text => top_text,
                             :bottom_text => bottom_text

    content_type 'image/jpeg'
    jesse.image_data
  end

end

# Render a pinkman image
def pinkman(text)

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
    text = Magick::Draw.new
    text.font_family = "helvetica"

    text.pointsize   = 35
    text.fill        = "#FFFFFF"
    text.stroke      = "#000000"
    text.font_weight = Magick::BoldWeight

    img.annotate(text, 0, 0, 0, 0, @top_text) do
      text.gravity     = Magick::NorthGravity
    end

    # bottom text
    text = Magick::Draw.new
    img.annotate(text, 0, 0, 0, 0, @bottom_text) do
      text.gravity     = Magick::SouthGravity
      text.stroke      = "#000000"
      text.fill        = "#FFFFFF"
      text.font_weight = Magick::BoldWeight
      text.pointsize  = 35
    end

    img.format = 'jpeg'
    img
  end
end
