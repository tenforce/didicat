class Cfg

  # Retrieves the configuration value for the supplied keyword.
  #
  # The keyword may be supplied in various formats.  Any format is first tried
  # in its to_s form.  If neither the environment, nor the yml file had the
  # requested variable, the variable is uppercased and the process is repeated.
  # The environment variables 'win' over the yml configuration file.
  def self.[]( arg )
    @sparql_config ||= loadYamlFiles

    false or
      ENV[arg.to_s] or
      ENV[arg.to_s.upcase] or
      @sparql_config[arg.to_s] or
      @sparql_config[arg.to_s.upcase]
  end

  # Provide a nicer way to access Config[:variable] as Config.variable
  def self.method_missing( method , *args )
    self[method]
  end

private

  # Loads all YAML files in /config/ddcat
  def self.loadYamlFiles
    hash = {}
    Dir.glob(File.join( Rails.root, 'config', 'didicat' , '*.yml' )).each do |file|
      hash = hash.deep_merge( YAML.load_file( file )[Rails.env] )
    end
    hash
  end

end
