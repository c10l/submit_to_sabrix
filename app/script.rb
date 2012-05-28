module Script
  def with_debug(description)
    begin
      $log.debug("Begin #{description}")
      yield
      $log.debug("Finished #{description}")
    rescue
      $log.debug("Something went wrong while #{description}")
      raise
    end
  end

  def generate_outdata_filename(path)
    filename = File.basename path
    @options.suffix ? postfix = "#{@options.suffix}.xml"
                    : postfix = '-outdata.xml'
    outfile = filename.sub(/-indata/i, '').sub('.xml', postfix)
  end

  def confirm(message, &block)
    return false if @options.no_to_all
    return true if @options.yes_to_all
    print "#{message}\n(y)es, (n)o, yes to (a)ll, (N)o to all > "
    answer = STDIN.gets.chomp.match(/^[ynaN][^.]*/).to_s
    case answer
    when nil
      puts 'Please choose y, n, a or N.'
      confirm(message)
    when 'y'
      true
    when 'a'
      @options.no_to_all = false
      @options.yes_to_all = true
      true
    when 'N'
      @options.yes_to_all = false
      @options.no_to_all = true
      yield if block_given?
      false
    else
      $log.warn 'defaulting to "no"'
      yield if block_given?
      false
    end
  end

end