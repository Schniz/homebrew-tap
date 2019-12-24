# frozen_string_literal: true

# Fnm formula :D
class Fnm < Formula
  VERSION = '1.18.0'
  desc 'Fast and simple Node.js version manager'
  homepage 'https://github.com/Schniz/fnm'
  url "https://github.com/Schniz/fnm/releases/download/v#{VERSION}/fnm-macos.zip"
  version VERSION
  sha256 'b04373fa6a5c2382d975a5086032b45e8f1dae5020912b8e8dba8dfcd01d5e8c'

  bottle :unneeded

  def install
    bin.install 'fnm'
  end

  def caveats
    if fnm_already_configured?
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

  def fnm_already_configured?
    x = File.read(File.expand_path(shell_profile))
    puts x
    x.include?('# fnm')
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
