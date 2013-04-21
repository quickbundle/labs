#encoding:utf-8

require 'zip/zip'
require 'time'
require "iconv"

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

class ZipUtil
  
  def self.add_to_zip_file(zip_file_name,file_paths)
    #如果文件已存在，则删除此文件
    if File.exist?(zip_file_name)
      #puts "文件已存在，将会删除此文件并重新建立。"
      File.delete(zip_file_name)
    end
    file_paths.each do |file_path|
      append_to_zip_file(zip_file_name, file_path)
    end
  end
  
  #压缩文件方法
  #zip_file_name 压缩文件绝对路径，含文件名
  #file_path 要解压的目录或文件
  def self.append_to_zip_file(zip_file_name,file_path)
    #start_path 表示
    def self.add_file(start_path,file_path,zip)
      start_path = encode_string(start_path)
      file_path = encode_string(file_path)
      #如果文件是一个目录则递归调用此方法
      if File.directory?(file_path)
        #建立目录
        #如果省略下一行代码，则当目录为空时，此目录将不会显示在压缩文件中
        zip.mkdir(file_path)
        #puts "建立目录#{file_path}"
        Dir.foreach(file_path) do |filename|
        #递归调用add_file方法
          add_file("#{start_path}/#{filename}","#{file_path}/#{filename}",zip) unless filename=="." or filename==".."
        end
      else
      #给压缩文件中添加文件
      #start_path 被添加文件在压缩文件中显示的路径
      #file_path 被添加文件的源路径
      zip.add(start_path,file_path)
      #puts "添加文件#{file_path}"
      end
    end

    #取得要压缩的目录父路径，以及要压缩的目录名
    chdir,tardir = File.split(file_path)
    #切换到要压缩的目录
    Dir.chdir(chdir) do
    #创建压缩文件
    #puts "开始创建压缩文件"
      Zip::ZipFile.open(zip_file_name,Zip::ZipFile::CREATE) do |zipfile|
      #puts "文件创建成功，开始添加文件..."
      #调用add_file方法，添加文件到压缩文件
      #puts "已添加文件列表如下:"
        add_file(tardir,tardir,zipfile)
      end
    end
  end
end

def encode_string(s)
  from = "UTF-8"
  to = "GBK"
  #return Iconv.iconv(to, from, s)[0]
  #return s.encode!(to, from)
  return s
end
  
def run(argv)
  if argv.length < 2
    puts "usage: ruby compress_file.rb ~/target/abc.zip ~/abc ..."
    return
  end
  
  ZipUtil.add_to_zip_file(argv[0], argv[1, argv.length-1])
end

run(ARGV)