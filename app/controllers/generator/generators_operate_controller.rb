# encoding: utf-8
require 'fileutils'
class Generator::GeneratorsOperateController < ApplicationController

  def index
  end

  def files_name
    @names = Dir["#{folder}*.rb"].select {|f| !File.directory? f}.map{|m|m.split('/')[-1].gsub(/.rb/,'')}
  end

  def delete_file file_name=nil
    respond_to do |format|
      file_name = params[:file_name] || file_name
      begin
        files_name.each do |f|
          File.delete("#{folder}#{f}.rb") if f == file_name
        end
        format.html { redirect_to files_name_generator_generators_operate_index_url, notice: '删除脚本成功.' }
      rescue =>e
        format.html { redirect_to files_name_generator_generators_operate_index_url, notice: '删除脚本失败.' }
      end
    end
  end

  def read_file
    file_name = params[:file_name]
    @file_content = ""
    path = "#{folder}#{file_name}.rb"
    File.open(path,'r') do |f|
      @file_content = f.read()
    end
    @file_content = @file_content.gsub!("ReportGenerator.configure do\n","")[0,@file_content.rindex("end")]
    render action: :index, file_content: @file_content
  end

  def create
    code = "ReportGenerator.configure do\n#{params[:code]}\nend"
    filename = "#{code.match(/#(.*)\*/)[1]}.rb"
    path = "#{folder}#{filename}"
    Dir.mkdir("#{folder}") if !File.exist?("#{folder}")
    File.open(path, 'wb') do|f|
      f.write(code)
    end
    result = reload_file(path)
    render text: result
  end

  def folder
    File.join(Rails.root,"app/generators/")
  end

  def reload_file(directory)
    begin
      load File.expand_path(directory, __FILE__)
    rescue SyntaxError => e
      return  "配置语法错误，请检查从新编辑."
    rescue NameError => e
      return  "配置名称错误，请检查从新编辑."
    end
    "配置写入成功."
  end
end

