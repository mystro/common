template do
  compute :backend do
    num 1
    role :backend
    flavor "m1.xlarge"
    userdata "chef"
    image "ami-3236ad5b" # 0.6.2.1
    group "backend"
    keypair "dev"
  end

  compute :frontend do
    num 1
    role :frontend
    flavor "m1.large"
    userdata "chef"
    image "ami-0145d268"
    group "frontend"
    keypair "dev"
  end

  compute :image do
    num 1
    role :image
    userdata "chef"
    flavor "m1.large"
    image "ami-ac8f13c5"
    group "frontend"
    keypair "dev"
  end
end
