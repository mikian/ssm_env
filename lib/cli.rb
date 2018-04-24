require 'aws-sdk-ssm'
require 'thor'
require 'yaml'

module SsmEnv
  class Cli < Thor
    class_option :app, desc: 'Application/job name to store secrets',
                 default: File.basename(Dir.pwd)

    desc 'pull', 'Pulls configuration from '
    def pull
      File.open(conf_file, 'w') { |f| f.write(parameters.to_yaml) }
    end

    desc 'push', 'Updates secrets on CI environment'
    def push
      secrets = YAML.load_file(conf_file)

      secrets.each do |name, value|
        next if parameters[name] == value

        resp = client.put_parameter(name: "#{path}/#{name}", value: value, type: 'SecureString', overwrite: true)
        say "Updated #{name}: v#{resp.version}"
      end

      say 'Secrets updated.'
    end

    no_commands do
      def conf_file
        '.ssm.yml'
      end

      def path
        "/jenkins/job/#{options.app}"
      end

      def client
        @client ||= Aws::SSM::Client.new
      end

      def parameters
        @parameters ||= fetch_parameters.to_h
      end

      def fetch_parameters(token: nil)
        response = client.get_parameters_by_path(
          path: path,
          recursive: true,
          with_decryption: true,
          next_token: token
        )

        result = []
        result += response.parameters.map do |param|
          [param.name.gsub("#{path}/", ''), param.value]
        end

        result += fetch_parameters(token: response.next_token) if response.next_token

        result
      end
    end
  end
end
