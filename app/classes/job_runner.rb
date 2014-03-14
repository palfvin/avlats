class JobRunner

  def initialize(processor = DocFiler)
    @processor = processor
  end

  def run
    Job.where(processed: nil).each do |job|
      @processor.new(ENV['COA_SCANS_NAME'], ENV['COA_SCANS_PASSWORD']).interpret_pdf(job.attachment_filename)
      job.processed = true
      job.save
    end
  end

end
