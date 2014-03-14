require 'rubygems'
require 'pry'
require 'prawn'

require 'rqrcode'
require 'prawn/qrcode'
require 'zxing'

class QRCodeSampleGenerator

  class << self

  UNITS_PER_INCH = 72
  ROWS = (1..7)
  COLS = (1..5)
  PAGE_HEIGHT = 11*UNITS_PER_INCH
  PAGE_WIDTH= 8.5*UNITS_PER_INCH
  CELL_HEIGHT = PAGE_HEIGHT/ROWS.last
  CELL_WIDTH = PAGE_WIDTH/COLS.last
  CODE_WIDTH = [CELL_WIDTH, CELL_HEIGHT].min

  def generate_sample_sheet
    prawn = Prawn::Document.new(margin: [0, 0, 0, 0])
    render_codes(prawn)
    prawn.render_file('foo.pdf')
  end

  def parse_sample_sheet(png_filename)
    each_cell do |row, col|
      x, y = position(row, col)
      width = CELL_WIDTH.to_f/PAGE_WIDTH
      height = CELL_HEIGHT.to_f/PAGE_HEIGHT
      crop = {x: x, y: y, width: width, height: height}
      binding.pry
      result = ZXing.decode(png_filename, crop: crop, rotate_and_retry_on_failure: true)
      puts "#{row}, #{col}: #{result}"
    end
  end

  private

  def each_cell
    ROWS.to_a.product(COLS.to_a).each { |row, col| yield(row, col) }
  end

  def render_codes(prawn)
    each_cell do |row, col|
      qr_code = RQRCode::QRCode.new(content, size: size(row, col), level: :m)
      dot_size = CODE_WIDTH.to_f/(8+qr_code.modules.length)
      puts "row = #{row}, col = #{col}, dot = #{dot_size}"
      puts position(row, col)
      @prawn.render_qr_code(qr_code, pos: position(row, col), dot: dot_size, stroke: false, extent: CODE_WIDTH)
    end
  end

  def position(row, col)
    x = (col-1)*CELL_WIDTH
    y = (row)*CELL_HEIGHT
    [x, y]
  end

  def size(row, col)
    (row-1)*COLS.max+col
    row
  end

  def content
    "bunk"
  end

  end

end
