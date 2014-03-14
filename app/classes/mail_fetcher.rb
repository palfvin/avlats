class MailFetcher

  def initialize(mail_retriever, job_creator = Job)
    @mail_retriever = mail_retriever
    @job_creator = job_creator
  end

  def run
    until (messages = @mail_retriever.find_and_delete).empty? do
      messages.each { |msg| process_message(msg) }
    end
  end

  private

  def process_message(message)
    return if message.attachments.length != 1
    return if (attachment = message.attachments[0]).content_type !~ /^application\/pdf;/
    job = @job_creator.create(sent_date: message.date, from: message.from[0])
    File.open("pdf/#{zero_padded(job.id,4)}.pdf", 'wb') { |file| file.write(attachment.body.decoded) }
  end

  def zero_padded(number, width)
    "%0#{width}d" % number
  end

end
