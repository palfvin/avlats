require 'spec_helper'

describe JobRunner do
  context "when job is present" do
    let(:job) { Job.create(sent_date: Date.today, from: "submitter@example.com")}
    subject { JobRunner.new.run }
    it "should process job" do
      doc_filer = double('doc filer')
      expect(DocFiler).to receive(:new).with(ENV['COA_SCANS_NAME'],ENV['COA_SCANS_PASSWORD']).and_return(doc_filer)
      expect(doc_filer).to receive(:interpret_pdf).with(job.attachment_filename)
      subject
      expect(job.reload.processed).to eq(true)
    end
  end
end
