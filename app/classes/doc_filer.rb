class DocFiler

  def initialize(name, password, options = {})
    o = {filer: GoogleDrive, root: 'scans'}.merge(options)
    root = o[:root] ; filer = o[:filer]
    @session = filer.login(name, password)
    @root = root
    change_working_collection_to_root
  end

  def interpret_pdf(filename)
    ipdf = CoverSheetedDoc.new(filename)
    ipdf.process_sets do |cover_text, pdf_filename|
      @pdf_filename = pdf_filename
      process_command(cover_text)
    end
  end

  def folder_exists?(path)
    saved_collection = @collection
    folder(path) # will raise error if not present
    true
  rescue
    @collection = saved_collection
    false
  end

  def file_exists?(path)
    saved_collection = @collection
    folder_path, filename = split_path(path)
    folder(folder_path) # will raise error if not present
    !@collection.files(title: filename, title_exact: true).empty?
  rescue
    @collection = saved_collection
    false
  end

  def delete_folder_contents
    @collection.files.each {|file| @collection.remove(file)}
  end

  def folder(path)
    change_working_collection_to_root if %r(^/) =~ path
    title_list = path.split('/')
    title_list.each {|title| change_working_collection(title)}
  end

  def add_nested_folders(path)
    change_working_collection_to_root if %r(^/) =~ path
    title_list = path.split('/')
    title_list.each do |title|
      next if title.blank?
      @collection = @collection.create_subcollection(title)
    end
  end

  def add_folder(path)
    exec_at_end_of_path(path) { |title| @collection = @collection.create_subcollection(title) }
  end

  def add_file(path)
    exec_at_end_of_path(path) do |title|
      remote_file = @session.upload_from_file(@pdf_filename, title)
      @collection.add(remote_file)
    end
  end
  alias :file :add_file

  private

  def exec_at_end_of_path(path, &block)
    change_working_collection_to_root if %r(^/) =~ path
    title_list = path.split('/')
    title_list[0..-2].each do |title|
      change_working_collection(title)
    end
    yield(title_list[-1])
  end

  def process_command(command)
    eval(command.downcase)
  rescue => e
    pry_me
    raise "Execution error: #{e}, from: #{command}"
  end

  def change_working_collection_to_root
    @collection = @session.root_collection
    change_working_collection(@root)
  end

  def change_working_collection(title)
    @collection = @collection.subcollection_by_title(title) unless title.empty?
    raise "Can't change to (#{title})" unless @collection
  end

  def split_path(path)
    path.match(%r{^(.*(?:^|/))([^/]+)$})[1..2]
  end

end

