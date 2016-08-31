module Dock
  module Warehouse
    class DataSource
      def initialize name
        @name = name
      end

      def name
        @name
      end

      def config
        @config ||= YAML.load_file("#{Rails.root}/config/database.yml")[name]
      end

      def username
        config["username"]
      end

      def password
        config["password"]
      end

      def database
        config["database"]
      end

      def host
        config["host"] || "127.0.0.1"
      end

      def port
        config["port"] || 3306
      end

      def connection
        ActiveRecord::Base.establish_connection(name).connection
      end

      def to_s
        "{ name: #{name}, host: #{host}, port: #{port}, database: #{database} }"
      end
    end
  end
end
