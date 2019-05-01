# frozen_string_literal: true

# Fnm formula :D
class Fnm < Formula
  VERSION = '1.9.0'
  desc 'Fast and simple Node.js version manager'
  homepage 'https://github.com/Schniz/fnm'
  url "https://github.com/Schniz/fnm/releases/download/v#{VERSION}/fnm-macos.zip"
  version VERSION
  sha256 '509f8c39f54b2f8c61e62165a1b4814b766d3b65597be172501f0699dc1fd564'

  bottle :unneeded

  def install
    bin.install 'fnm'
  end

  def caveats
    if File.read(File.expand_path(shell_profile)).include?('# fnm')
      <<~CAVEATS
        Skipped the installation of fnm to #{shell_profile} because I found `# fnm`.
        In case you want to do it manually, add the following to the file:

          # fnm
          #{source_for_shell}
      CAVEATS
    else
      setup_shells
      "No `# fnm` in #{shell_profile}, so fnm was installed to it."
    end
  end

  def source_for_shell
    if preferred == 'fish'
      'fnm env --multi | source'
    else
      %{eval "$(fnm env --multi)"}
    end
  end

  def setup_shells
    File.open(File.expand_path(shell_profile), 'a') do |f|
      f << "# fnm\n"
      f << "#{source_for_shell}\n"
    end
  end

  test do
    system "#{bin}/fnm", '--version'
  end
end
