class Job < ActiveRecord::Base
  def attachment_filename
    "pdf/#{'%04d' % id}.pdf"
  end
end
