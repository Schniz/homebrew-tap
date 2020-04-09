# frozen_string_literal: true

# Fnm formula :D
class Fnm < Formula
  attr_accessor :shell_configuration_failure

  VERSION = '1.20.0'
  desc 'Fast and simple Node.js version manager'
  homepage 'https://github.com/Schniz/fnm'
  version VERSION

  if OS.mac?
    url "https://github.com/Schniz/fnm/releases/download/v#{VERSION}/fnm-macos.zip"
    sha256 '3574a2df4fd5a484c6c4f848cf86a08c6393be252b0bf0984debb863f52638a4'
  else
    url "https://github.com/Schniz/fnm/releases/download/v#{VERSION}/fnm-linux.zip"
    sha256 'e0a4784cb297adf23fc6b9de16da41df4fb5dbba1ccc125b8c50a67acba91c30'
  end

  bottle :unneeded

  test do
    system "#{bin}/fnm", '--version'
  end

  def install
    bin.install 'fnm'
  end

  def caveats
    <<~CAVEATS
      Thanks for installing fnm!
      The last step for making fnm work is to run it on the shell startup, using the `fnm env` command.

      In order to complete the installation, please add the following to your shell profile:

        # fnm
        #{source_for_shell}

      Homebrew tells us that #{preferred} is your preferred shell,
      and your shell profile is at #{shell_profile.inspect}, if that helps 😇

      > btw, if you know how to make this process automated, help us out with a PR!
      > the code is here: https://github.com/Schniz/homebrew-tap/blob/master/Formula/fnm.rb
    CAVEATS
  end

  def source_for_shell
    if preferred == 'fish'
      'fnm env --multi | source'
    else
      %{eval "$(fnm env --multi)"}
    end
  end
end
