module Api
  class Code
        
    def initialize(options={}, &block)
      @options  = options
      @codepath = File.expand_path(@options['codepath'])
      @sslcert  = File.expand_path(@options['client_cert'])
      @sslkey   = File.expand_path(@options['client_key'])
      @cacert   = File.expand_path(@options['ca_cert'])
      
      @continue = true
      
      # Clone repo if it doesn't exist.
      FileUtils::mkdir(@codepath) unless File.directory?(@codepath)
      unless File.exists?("#{@codepath}/.git")
        clonerepo
        @continue = false
      end
      @repo = Git::init(@codepath)
    end
    
    def commit(message)
      @repo.add('*')
      @repo.commit(message)
    end
    
    def download
      if @continue
        @repo.pull
      else
        return 'Completed'
      end
    end
    
    def publish
      @repo.push
      return "Published to repository"
    end
    
    def clonerepo
      # Create directory and clone
      puts "Cloning repository"
       
      # We need to configure our certificates, hence this is all the individual
      # steps required for a clone
      @repo = Git::init(@codepath)
      @repo.config('http.sslCert', @sslcert)
      @repo.config('http.sslKey', @sslkey)
      @repo.config('http.sslCAInfo', @cacert)
      remote = @repo.add_remote('origin', "https://#{@options['hostname']}/#{@options['repo']}")
      @repo.branch('master')
      @repo.fetch
    end
    
  end
end