class Command::CommandCenter

	def initialize
		load_commands
	end

	def run id
		command = Command::CommandCenter.subclasses.collect(&:new).select{ |r| r.match? id }.first
		command.run
	end

	def match? id
		self.class.name.split("::").last.split("Command").first.underscore.to_sym == id
	end

	private
		def load_commands
			commands = Dir.glob(File.expand_path("../../command/*",__FILE__))
			commands.each{|cmd| load cmd }
		end
end
