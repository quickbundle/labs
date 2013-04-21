#encoding:utf-8

$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))  
require 'time'
require 'compress_file'

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

def compress_file(save_name, targets)
  save_name = save_name + '-' + Time.new.strftime("%Y%m%d-%H%M%S")
  if system 'tar --help'
    exec_targz(save_name, targets)
  else
    ZipUtil.add_to_zip_file(save_name + ".zip", targets)
  end
end

def exec_targz(save_name, targets)
  cmd = "tar czvf " + save_name + ".tar.gz"
  targets.each do |target|
    cmd += " " + target
  end
  puts 'result=>', system(cmd)
end

def run(argv)
  if argv.length < 2
    puts "usage: ruby bak_file.rb abc ~/abc11 ~/abc22 ..."
    return
  end
  
  compress_file(argv[0], argv[1, argv.length-1])
end

run(ARGV)