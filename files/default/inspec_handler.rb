require 'inspec'

module InspecHandler
  class Report < ::Chef::Handler

    def initialize(config = {})
      @config = config
    end

    def report


      @config[:profile_paths].each do |path|
        inspec_cmd = Mixlib::ShellOut.new("#{::File.join(@config[:inspec_path], 'inspec')} exec #{path}", returns: [0, 101])
        inspec_cmd.run_command
        puts inspec_cmd.stdout
        unless [0, 101].include?(inspec_cmd.exitstatus)
          # raise "Inspec Failure!"
          Chef::Log.fatal("FATAL: Error running Inspec tests!")
          Chef::Log.error("ERROR: Error running Inspec tests!")
        end
        # inspec_cmd.error!
      end
    end

  end
end
