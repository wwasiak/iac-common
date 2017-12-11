require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file("/etc/environment") do
  it { should exist }
  it { should be_owned_by 'root' }
  its(:content) { should match /^http_proxy=http:\/\/web-proxy/ }
  its(:content) { should match /^https_proxy=http:\/\/web-proxy/ }
  its(:content) { should match /^no_proxy=\"localhost/ }
end
