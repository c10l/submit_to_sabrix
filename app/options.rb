class Options
  require 'optparse'
  load File.join(File.dirname(__FILE__), 'script.rb')
  include Script

  attr_accessor :yes_to_all, :no_to_all
  attr_reader :no_audit, :suffix, :file_list, :url_list

  # TODO: Add an option to use a list of URLs

  def initialize(args = [])
    @options ||= args
    @options = ['--help'] if @options.length == 0

    optparse = OptionParser.new do |opts|
      opts.banner = "\nUsage: submit_to_sabrix.rb [options] file1 file2 ...\n\n"
      opts.banner += "Options:\n\n"

      opts.on('-u', '--url URL', 'Post to URL') do |url|
        raise 'Invalid URL, please begin with http://' unless url =~ /^http:\/\//
        @url_list ||= []
        @url_list << url
        # $sabrix = Sabrix.new(url)
      end

      opts.on('-U', '--url-list FILENAME', 'List of URLs to post to (one per line)') do |file|
        @url_list = File.read(file).split("\n")
      end

      @yes_to_all = false
      opts.on('-y', '--yes-to-all', 'Skip safeguards -- USE WITH CAUTION!') do
        @yes_to_all = true
      end

      @no_to_all = false
      opts.on('-n', '--no-to-all', 'Respond NO to all safeguard validations (safe)') do
        @no_to_all = true
        @yes_to_all = false
      end

      @no_audit = false
      opts.on('-a', '--no-audit', 'Force IS_AUDITED to false') do
        @no_audit = true
      end

      @suffix = nil
      opts.on('-s', '--suffix TEXT', 'Add TEXT to the end of the outdata filename') do |suffix|
        @suffix = suffix
      end

      # $log.level = Logger::INFO
      # opts.on('-d', '--debug', 'Display debug messages') do
      #   $log.level = Logger::DEBUG
      # end

      opts.on('-h', '--help', 'Display this screen') do
        puts "#{opts}\n"
        exit
      end
    end
    optparse.parse! @options
    raise 'No files specified.' if @options.length == 0
    @file_list = @options
  end
end