class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def process_jobs
    mail_retriever = Mail::IMAP.new(
      address: 'imap.gmail.com',
      port: 993,
      user_name: ENV['COA_SCANS_NAME'],
      password: ENV['COA_SCANS_PASSWORD'],
      enable_ssl: true)
    MailFetcher.new(mail_retriever).run
    JobRunner.new.run
    render :home
  end
  
end
