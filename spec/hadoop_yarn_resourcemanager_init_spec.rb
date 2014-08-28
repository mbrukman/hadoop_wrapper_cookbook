require 'spec_helper'

describe 'hadoop_wrapper::hadoop_yarn_resourcemanager_init' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        node.override['hadoop']['yarn_site']['yarn-remote-app-log-dir'] = '/tmp/yarn-app-log-dir'
        stub_command("hdfs dfs -ls hdfs://fauxhai.local | grep ' /tmp' | grep -e '^drwxrwxrwt'").and_return(false)
        stub_command('hdfs dfs -ls hdfs://fauxhai.local/tmp/yarn-app-log-dir').and_return(false)
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
      end.converge(described_recipe)
    end

    it 'runs initaction-create-hdfs-tmpdir ruby_block' do
      expect(chef_run).to run_ruby_block('initaction-create-hdfs-tmpdir')
    end

    it 'runs initaction-create-yarn-remote-app-log-dir ruby_block' do
      expect(chef_run).to run_ruby_block('initaction-create-yarn-remote-app-log-dir')
    end
  end
end