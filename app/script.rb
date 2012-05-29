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

  def generate_outdata_filename(file, sabrix)
    prefix = sabrix.url.match(/[^http:\/\/][^\.]+/).to_s + '_' + sabrix.url.match(/:\d+\//).to_s[1..-2] + '_'
    filename = File.basename file
    @options.suffix ? postfix = "#{@options.suffix}.xml"
                    : postfix = '-outdata.xml'
    prefix + filename.sub(/-indata/i, '').sub('.xml', postfix)
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

  def post(indata, sabrix, outfile)
    $log.info "=> Submitting to Sabrix on #{sabrix.url}"
    @outdata = sabrix.submit indata.xml

    with_debug("saving file #{outfile}") do
      begin
        file = File.open(outfile, "w")
        $log.info "=> Saving to #{File.basename(file)} ..."
        file.puts @outdata.body
      ensure
        file.close
      end
    end
  end
end