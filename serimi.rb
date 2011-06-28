require 'optparse'
require 'optparse/uri'
require 'serimi_class'

options = {}

opts = OptionParser.new do |opts|

  opts.banner = "Usage: serimi.rb [options] \n\nExample of use: \nruby serimi.rb -s http://localhost:8890/sparql -t http://dbpedia.org/sparql?default-graph-uri=http://dbpedia.org -c http://www.semwebtech.org/mondial/10/meta#Country \n"

  # Define the options, and what they do
  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end
  options[:logfile] = nil
  opts.on( '-l', '--logfile FILE', 'Write log to FILE' ) do |file|
    options[:logfile] = file
  end
  options[:source] = nil
  opts.on( '-s URI', '--source SPARQL_URI', String, 'Source Virtuoso sparql endpoint - URI' ) do |uri|
    raise OptionParser::InvalidArgument, uri + ", not a valid URI."  if !(uri =~ /^http[s]?:\/\//)

    options[:source] = uri
  end
  options[:target] = nil
  opts.on( '-t URI', '--target SPARQL_URI', String, 'Target Virtuoso sparql endpoint - URI' ) do |uri|
    raise OptionParser::InvalidArgument, uri + ", not a valid URI."  if !(uri =~ /^http[s]?:\/\//)

    options[:target] = uri
  end
  options[:class] = nil
  opts.on( '-c URI', '--class URI',String,  'Source class for interlink - URI' ) do |uri|
    raise OptionParser::InvalidArgument, uri + ", not a valid URI."  if uri == nil || !(uri =~ /^http[s]?:\/\//)

    options[:class] = uri
  end
  options[:output] = "./output.txt" 
    opts.on( '-o FILE_NAME', '--output FILE', String, 'Write output to FILE - Default=./output.txt' ) do |file|
    options[:output] = file
  end
  options[:format] = "txt"
  opts.on( '-f', '--output-format value', String, 'Output format: txt, nt. Default=txt' ) do |c|
    options[:format] = c
  end
   options[:chunk] = 20
  opts.on( '-k', '--chunk value', Integer, 'Chunk size - Default=20' ) do |c|
    options[:chunk] = c
  end
   options[:offset] = 0
  opts.on( '-b', '--offset value', Integer, 'Start processing from a specific offset - Default=0' ) do |c|
    options[:offset] = c
  end
   options[:stringthreshold] = 0.7
  opts.on( '-x', '--string-threshold value', Float, 'String distance threshold. A value between [0,1] - Default=0.7' ) do |c|
    options[:stringthreshold] = c
  end
   options[:rdsthreshold] = nil
  opts.on( '-y', '--rds-threshold value', Float, 'RDS threshold. A value between [0,1] - Default=max(media,mean)' ) do |c|
    options[:rdsthreshold] = c
  end
  
  options[:logfile] = nil
  opts.on( '-l', '--logfile FILE', 'Write log to FILE' ) do |file|
    options[:logfile] = file
  end
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
begin
  opts.parse!
  mandatory = [:source, :class, :target]                                         # Enforce the presence of
  missing = mandatory.select{ |param| options[param].nil? }        # the -t and -f switches
  if not missing.empty?                                            #
  puts "Missing options: #{missing.join(', ')}"                  #
  puts opts                                                  #
  exit                                                           #
  end                                                              #
rescue OptionParser::InvalidOption, OptionParser::MissingArgument      #
  puts $!.to_s                                                           # Friendly output when parsing fails
  puts opts                                                          #
  exit                                                                   #
end                                                                      #
puts "Being verbose" if options[:verbose]
puts "Logging to file #{options[:logfile]}" if options[:logfile]
# $activerdflog.level = Logger::DEBUG
Serimi.new(options)