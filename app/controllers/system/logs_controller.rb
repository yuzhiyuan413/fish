class System::LogsController < ApplicationController
  around_filter :verifi_log_path

  def index
  end

  def dir
    @log_files = Dir.glob(File.join(@log_dir,"**")).map{|path| path if File.file?(path)}.delete_if{|v| v==nil}
    Rails.logger.debug { "*"*80  }
    Rails.logger.debug { @log_files }
  end

  def log_file
    line = params[:line] || 100
    @grep = params[:grep]
    @line = line.to_i >= 200 ? 200 : line.to_i
    @after = params[:after].to_i || 0
    @before = params[:before].to_i || 0
    if @grep.to_s.strip.size > 0
      @log_lines = LogFile.egrep(@log_file, :linenum => @line, :regx => @grep, :after => @after, :before => @before)
    else
      @log_lines = LogFile.tail(@log_file, :linenum => @line)
    end
  end

  def down_log
    send_file @log_file
  end

  private
    def clean_path(s)
      '' unless s
      s.gsub!(/'|"/,'')
      s.gsub!(/>+/,'')
      s.gsub!(/<+/,'')
      s.gsub!(/\|/,'')
      File.expand_path(s)
    end

    def verifi_log_path
      if _logdir = params[:logdir]
        @log_dir = clean_path(_logdir)
        Rails.logger.debug { "log_dir: #{@log_dir}" }
        raise RuntimeError.new("非法操作") unless LOG_DIR.include?(@log_dir)
      end

      if params[:logfile]
        @log_file = clean_path(params[:logfile])
        Rails.logger.debug { "log_file: #{@log_file}" }
        raise IOError.new("文件不存在") unless File.exists?(@log_file)
        raise RuntimeError.new("非法操作") unless LOG_DIR.include?(File.dirname(@log_file))
      end
      yield
    end

end
