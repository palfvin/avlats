
class MockIMAP
  @@connection = false
  @@mailbox = nil
  @@marked_for_deletion = []

  def self.examples
    @@examples
  end

  def initialize(examples)
    @@examples = examples
  end

  def login(user, password)
    @@connection = true
  end

  def disconnect
    @@connection = false
  end

  def select(mailbox)
    @@mailbox = mailbox
  end

  def examine(mailbox)
    select(mailbox)
  end

  def uid_search(keys, charset=nil)
    [*(0..@@examples.size - 1)]
  end

  def uid_fetch(set, attr)
    [@@examples[set]]
  end

  def uid_store(set, attr, flags)
    if attr == "+FLAGS" && flags.include?(Net::IMAP::DELETED)
      @@marked_for_deletion << set
    end
  end

  def expunge
    @@marked_for_deletion.reverse.each do |i|    # start with highest index first
      @@examples.delete_at(i)
    end
    @@marked_for_deletion = []
  end

  def self.mailbox; @@mailbox end    # test only

  def self.disconnected?; @@connection == false end
  def      disconnected?; @@connection == false end

end

require 'net/imap'
class Net::IMAP
  def self.new(*args)
    MockIMAP.new
  end
end
