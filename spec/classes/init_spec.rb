require 'spec_helper'
describe 'glpi', :type => 'class' do
  platforms = {
    'debian6' =>
      { :osfamily          => 'Debian',
        :release           => '6.0',
        :majrelease        => '6',
        :lsbdistcodename   => 'squeeze',
        :packages          => 'glpi',
      },
    'debian7' =>
      { :osfamily          => 'Debian',
        :release           => '7.0',
        :majrelease        => '7',
        :lsbdistcodename   => 'wheezy',
        :packages          => 'glpi',
      },
    'debian8' =>
      { :osfamily          => 'Debian',
        :release           => '8.0',
        :majrelease        => '8',
        :lsbdistcodename   => 'jessie',
        :packages          => 'glpi',
      },
    'ubuntu1004' =>
      { :osfamily          => 'Debian',
        :release           => '10.04',
        :majrelease        => '10',
        :lsbdistcodename   => 'lucid',
        :packages          => 'glpi',
      },
    'ubuntu1204' =>
      { :osfamily          => 'Debian',
        :release           => '12.04',
        :majrelease        => '12',
        :lsbdistcodename   => 'precise',
        :packages          => 'glpi',
      },
    'ubuntu1404' =>
      { :osfamily          => 'Debian',
        :release           => '14.04',
        :majrelease        => '14',
        :lsbdistcodename   => 'trusty',
        :packages          => 'glpi',
      },
    'ubuntu1604' =>
      { :osfamily          => 'Debian',
        :release           => '16.04',
        :majrelease        => '16',
        :lsbdistcodename   => 'xenial',
        :packages          => 'glpi',
      },
  }

  describe 'with default values for parameters on' do
    platforms.sort.each do |k, v|
      context "#{k}" do
        let :facts do
          { :lsbdistcodename           => v[:lsbdistcodename],
            :osfamily                  => v[:osfamily],
            :kernelrelease             => v[:release],        # Solaris specific
            :operatingsystemrelease    => v[:release],        # Linux specific
            :operatingsystemmajrelease => v[:majrelease],
          }
        end

        it { should compile.with_all_deps }

        it { should contain_class('glpi') }

        if v[:packages].class == Array
          v[:packages].each do |pkg|
            it do
              should contain_package(pkg).with({
                'ensure'   => 'present',
                'provider' => nil,
              })
            end
          end
        else
          it do
            should contain_package(v[:packages]).with({
              'ensure'   => 'present',
              'provider' => nil,
            })
          end
        end

        it do
          should contain_file('/etc/glpi/rc').with({
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
          })
        end

        glpi_rc_fixture = File.read(fixtures("rc.#{k}"))
        it { should contain_file('/etc/glpi/rc').with_content(glpi_rc_fixture) }

      end
    end
  end

  describe 'parameter functionality' do
    let(:facts) do
      {
        :osfamily        => 'Debian',
        :lsbdistcodename => 'squeeze',
      }
    end

    context 'when always_query_hostname is set to valid bool <true>' do
      let(:params) { { :always_query_hostname => true } }
      it { should contain_file('/etc/glpi/rc').with_content(/^ALWAYS_QUERY_HOSTNAME=true$/) }
    end

    context 'when package_ensure is set to valid string <absent>' do
      let(:params) { { :package_ensure => 'absent' } }
      it { should contain_package('glpi').with_ensure('absent') }
    end

    context 'when package_name is set to valid string <glpi>' do
      let(:params) { { :package_name => 'glpi' } }
      it { should contain_package('glpi').with_name('glpi') }
    end
  end

  describe 'failures' do
    let(:facts) do
      {
        :osfamily        => 'Debian',
        :lsbdistcodename => 'squeeze',
      }
    end

    context 'when osfamily is unsupported' do
      let :facts do
        { :osfamily                  => 'Unsupported',
          :operatingsystemmajrelease => '9',
        }
      end

      it 'should fail' do
        expect do
          should contain_class('glpi')
        end.to raise_error(Puppet::Error, /glpi supports osfamilies Debian\. Detected osfamily is <Unsupported>\./)
      end
    end
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      {
        :osfamily                  => 'Debian',
        :operatingsystemrelease    => '6.0',
        :operatingsystemmajrelease => '6',
        :lsbdistcodename           => 'squeeze',
      }
    end
    let(:validation_params) do
      {
        #:param => 'value',
      }
    end

    validations = {
      'bool_stringified' => {
        :name    => %w(always_query_hostname),
        :valid   => [true, 'true', false, 'false'],
        :invalid => ['invalid', 3, 2.42, %w(array), { 'ha' => 'sh' }, nil],
        :message => '(is not a boolean|Unknown type of boolean)',
      },
      'string' => {
        :name    => %w(package_ensure package_name),
        :valid   => ['present'],
        :invalid => [%w(array), { 'ha' => 'sh' }],
        :message => 'is not a string',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:valid].each do |valid|
          context "with #{var_name} (#{type}) set to valid #{valid} (as #{valid.class})" do
            let(:params) { validation_params.merge({ :"#{var_name}" => valid, }) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "with #{var_name} (#{type}) set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { validation_params.merge({ :"#{var_name}" => invalid, }) }
            it 'should fail' do
              expect do
                should contain_class(subject)
              end.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
