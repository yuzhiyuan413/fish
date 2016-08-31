log_viewer_config = File.join(Rails.root,"config","log_dir.yml")
LOG_DIR = File.exists?(log_viewer_config) ? YAML::load_file(log_viewer_config) : []
