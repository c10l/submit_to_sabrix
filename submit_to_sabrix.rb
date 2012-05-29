#!/usr/bin/env ruby

require 'rubygems'
require 'logger'
Dir[File.join(File.dirname(__FILE__), "app/*")].each { |file| load file }
include Script

$log = Logger.new STDERR
$log.level = Logger::INFO

@options = Options.new(ARGV)

@options.file_list.each do |file|
  $log.info "Reading file #{file} ..."
  indata = Invoice.new File.read(file)

  $log.warn "Flag IS_AUDITED set to #{indata.is_audited?}"

  indata.set_audit(false) if @options.no_audit

  if indata.is_audited? then
    $log.info 'WARNING! This transaction will be audited and should not be posted to Production.'
    next unless confirm('Continue anyway? ') { $log.info "Skipping ...\n\n" }
  end

  @options.url_list.each do |url|
    sabrix = Sabrix.new(url)

    $log.info "Will post to #{sabrix.url}"

    outfile = generate_outdata_filename file, sabrix
    if FileTest.exists?(outfile) then
      next unless confirm("File #{outfile} exists. Overwrite? ") { $log.info "File exists -- Skipping ...\n\n" }
    end

    post indata, sabrix, outfile
  end

  puts # Prints out one blank line at the end of the execution
end