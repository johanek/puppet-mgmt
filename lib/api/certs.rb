module Api
  class Certs
    
    def initialize(options={}, &block)
      @block = block
      @options = options
      @baseuri = "https://#{options['hostname']}:#{options['port']}/#{options['environment']}"
      @req = Api::Rest.new
      @req.client_cert = options['client_cert']
      @req.client_key = options['client_key']
      @req.ca_cert = options['ca_cert']
    end
      
    def checkhost(hostname)
      url = "#{@baseuri}/certificate_status/#{hostname}"
      PSON.parse(@req.get(url, 'pson'))
    rescue RestClient::ResourceNotFound
      puts "No certificate found for #{hostname}"
      exit 1
    end
    
    def listcerts()
      url = "#{@baseuri}/certificate_statuses/no_key"
      PSON.parse(@req.get(url, 'pson'))
    end

    def listcertreqs()
      url = "#{@baseuri}/certificate_requests/all"
      @req.get(url, 'YAML')
    end

    def signcert(hostname)
      url = "#{@baseuri}/certificate_status/#{hostname}"
      data = { 'desired_state' => 'signed' }
      @req.put(url, data.to_pson)
    rescue RestClient::BadRequest
      puts "No certificate request found for #{hostname}"
      exit
    end
    
    def cleancert(hostname)
      revokecert(hostname)
      deletecert(hostname)
    end
    
    def deletecert(hostname)
      url = "#{@baseuri}/certificate_status/#{hostname}"
      @req.delete(url)
    end
        
    def revokecert(hostname)
        url = "#{@baseuri}/certificate_status/#{hostname}"
        data = { 'desired_state' => 'revoked' }
        @req.put(url, data.to_pson)
      rescue RestClient::BadRequest
        puts "No certificate request found for #{hostname}"
        exit
    end
  
  end
end
