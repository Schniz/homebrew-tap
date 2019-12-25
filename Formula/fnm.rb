# frozen_string_literal: true

# Fnm formula :D
class Fnm < Formula
  attr_accessor :shell_configuration_failure

  VERSION = '1.18.0'
  desc 'Fast and simple Node.js version manager'
  homepage 'https://github.com/Schniz/fnm'
  url "https://github.com/Schniz/fnm/releases/download/v#{VERSION}/fnm-macos.zip"
  version VERSION
  sha256 'b04373fa6a5c2382d975a5086032b45e8f1dae5020912b8e8dba8dfcd01d5e8c'

  bottle :unneeded

  option "without-shell-config", "Don't configure the shell"

  test do
    system "#{bin}/fnm", '--version'
  end

  def install
    bin.install 'fnm'

    if configure_shell?
      configure_shell
    end
  end

  def caveats
    if configure_shell?
      if shell_configuration_failure.nil?
        "No `# fnm` in #{shell_profile}, so fnm was installed to it."
      else
        <<~CAVEATS
          Failed installing fnm to your shell file:
          #{shell_configuration_failure.inspect}

          We assumed your shell is #{preferred} and the file is at #{shell_profile.inspect}.
          To install it manually, add the following to the file:

            # fnm
            #{source_for_shell}
        CAVEATS
      end
    else
      <<~CAVEATS
        Skipped the installation of fnm to #{shell_profile} because I found `# fnm`.
        In case you want to do it manually, add the following to the file:

          # fnm
          #{source_for_shell}
      CAVEATS
    end
  end

  def configure_shell?
    @shell_already_configured ||= fnm_already_configured?
    !@shell_already_configured
  end

  def fnm_already_configured?
    build.without?('shell-config') ||
      File.read(File.expand_path(shell_profile)).include?('# fnm')
  rescue
    puts "Can't read shell profile!"
    false
  end

  def source_for_shell
    if preferred == 'fish'
      'fnm env --multi | source'
    else
      %{eval "$(fnm env --multi)"}
    end
  end

  def configure_shell
    File.open(File.expand_path(shell_profile), 'a') do |f|
      f << "\n# fnm\n"
      f << "#{source_for_shell}\n"
    end
  rescue => e
    self.shell_configuration_failure = e
  end
end
