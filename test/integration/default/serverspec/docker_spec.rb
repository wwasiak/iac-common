require 'serverspec'

# Required by serverspec
set :backend, :exec

describe service('docker') do
  it { should be_enabled }
  it { should be_running }
end

describe file("/etc/sysconfig/docker") do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  its(:content) { should match /^HTTP_PROXY=http:\/\/web-proxy/ }
  its(:content) { should match /^HTTPS_PROXY=http:\/\/web-proxy/ }
  its(:content) { should match /^NO_PROXY=\"localhost/ }
end

describe command("sudo docker ps") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /CONTAINER ID/ }
end

describe command("sudo docker run -d --name kitchen-tmp busybox") do
  its(:exit_status) { should eq 0 }
end

describe command("sudo docker stop kitchen-tmp") do
  its(:exit_status) { should eq 0 }
end

describe command("sudo docker rm kitchen-tmp") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /kitchen-tmp/ }
end

describe file("/opt/mount1/docker") do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'root' }
end

describe file("/opt/mount1/docker/image") do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'root' }
end

describe file("/etc/docker/daemon.json") do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  its(:content_as_json) { should include('graph' => '/opt/mount1/docker') }
end


#HACK that makes kitchen test go without errors
#when docker stop/kill is executed on a container with running docker within, it produces a nasty error
#we must stop the service manually, as kitchen or docker does not seem to provide any customization
#for stopping containers
#SIDE-EFFECT: if kitchen test is run several times, it fails the first test (service running) from the second time on
describe command("sudo service docker stop") do
  its(:exit_status) { should eq 0 }
end

