require 'spec_helper'

describe MailFetcher do
  let(:file_contents) {Random.new.bytes(123456)}

  describe "should create a job from an incoming mail" do
    before do
      attachment = double("Attachment", :content_type => "application/pdf; name=test.pdf")
      allow(attachment).to receive_message_chain(:body, :decoded).and_return(file_contents)
      @message = double("Message", :date => Date.today, :from => ["testsender@example.com"], attachments: [attachment],
                       :mark_for_delete= => nil, :is_marked_for_delete? => true)
      @mail_retriever = Mail::TestRetriever.new(nil)
      Mail::TestRetriever.emails = [@message]
    end
    subject { MailFetcher.new(@mail_retriever, @job_creator).run }
    after do
      expect(File.exists?(@job.attachment_filename)).to be_truthy
      expect(File.open(@job.attachment_filename, 'rb') {|f| f.read}).to eq(file_contents)
      File.delete(@job.attachment_filename)
    end
    specify 'using ActiveRecord double' do
      @job = double("job", id: 42, attachment_filename: 'pdf/0042.pdf')
      @job_creator = double("Job")
      expect(@job_creator).to receive(:create).with(sent_date: @message.date, from: @message.from[0]).and_return(@job)
      subject
    end
    specify 'using ActiveRecord' do
      @job_creator = Job
      subject
      @job = Job.last
      expect(@job.sent_date).to eq(@message.date)
      expect(@job.from).to eq(@message.from[0])
    end
  end
end
