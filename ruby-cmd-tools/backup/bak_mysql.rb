#encoding:utf-8

$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))  
require 'time'

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

def mysqldump(mysql_arguments, targets)
  targets.each do |target|
    cmd = 'mysqldump ' + target + ' ' + mysql_arguments + ' >' + target + '-' + Time.new.strftime("%Y%m%d-%H%M%S") + '.sql'
    system(cmd)
  end
end

def run(argv)
  if argv.length < 2
    puts 'usage: ruby bak_mysql.rb "-h localhost -p 3306 -u root -p password" db1 db2'
    return
  end
  mysqldump(argv[0], argv[1, argv.length-1])
end

run(ARGV)
