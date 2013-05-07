template do
  balancer :frontend do
    primary true
    listener do
      from "https:443"
      to "http:80"
      cert "arn:aws:iam::595408174370:server-certificate/2013inqlabs.com"
    end
    listener do
      from "http:80"
      to "http:80"
    end
    health do
      target "HTTP:80/"
    end
  end

  balancer :backend do
    listener do
      from "http:8080"
      to "http:8080"
    end
    health do
      target "HTTP:8080/INQReaderServer/rest/AjaxConfig/config"
    end
  end

  balancer :image do
    listener do
      from "http:80"
      to "http:80"
    end
    health do
      target "HTTP:80/getImages?url=http%3A%2F%2Fwww.bbc.co.uk%2Fnews%2Fworld-us-canada-21638727"
      interval 120
      timer 60
      unhealthy 3
      healthy 10
    end
  end

  compute :backend do
    num 3
    role :backend
    flavor "m1.xlarge"
    userdata "chef"
    image "ami-3236ad5b" # 0.6.2.1
    group "backend"
    keypair "live"
    balancer :backend
  end

  compute :frontend do
    num 3
    role :frontend
    flavor "m1.medium"
    userdata "chef"
    image "ami-0145d268"
    group "frontend"
    keypair "live"
    balancer :frontend
  end

  compute :image do
    num 5
    role :image
    balancer :image
    userdata "chef"
    flavor "m1.large"
    image "ami-ac8f13c5"
    group "frontend"
    keypair "live"
  end
end
