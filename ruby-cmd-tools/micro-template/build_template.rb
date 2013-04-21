#encoding:utf-8

require 'time'

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

def run(argv)
  if argv.length == 0
    puts "usage: ruby build_template.rb 2013-01-01
       ruby build_template.rb 2013-01-01 2013-01-03"
    return
  end
  if argv.length > 0
    date = argv[0]
  end
  if argv.length > 1
    date2 = argv[1]
  end
  if argv.length > 2 and argv[2] == 'all'
    t1 = Time.mktime(date[0,4], date[5,7], date[8,10])
    t2 = Time.mktime(date2[0,4], date2[5,7], date2[8,10])
    puts t1, t2
    t = t1
    while t <= t2
      buildTemplate(t.strftime("%Y-%m-%d"), nil)
      t = Time.at(t.to_i + 24 * 60 * 60)
    end
      
  else
    buildTemplate(date, date2)
  end
end

def buildTemplate(date, date2)
  if(!File.exist?("target"))
    Dir.mkdir("target")
  end
  out = File.new("target/" + date + ".txt", "w")  #创建一个可写文件流
  File.open("template.txt", "r") do |file|
    template = file.read
    newValue = template.gsub(/\{(.*?)\}/m){
      eval($1) }
    out.puts newValue
  end
  puts 'output: target/' + date + ".txt"
  out.close #关闭文件流
end

run(ARGV)