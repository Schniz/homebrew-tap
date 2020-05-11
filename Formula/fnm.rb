class Fnm < Formula
  attr_accessor :shell_configuration_failure

  VERSION = "1.20.0".freeze
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/releases/download/v#{VERSION}/fnm-macos.zip"
  sha256 "3574a2df4fd5a484c6c4f848cf86a08c6393be252b0bf0984debb863f52638a4"

  bottle :unneeded

  def install
    bin.install "fnm"
    chmod "+x", bin/"fnm"
    %w[
      alias
      default
      env
      exec
      install
      ls
      ls-remote
      uninstall
      use
    ].each do |cmd|
      (man1/"fnm-#{cmd}.1").write `#{bin}/fnm #{cmd} --help=groff`
    end
    (man1/"fnm.1").write `#{bin}/fnm --help=groff`
  end

  def caveats
    <<~EOS
      Thanks for installing fnm!
      The last step for making fnm work is to run it on the shell startup, using the `fnm env` command.

      In order to complete the installation, please add the following to your shell profile:

        # fnm
        #{source_for_shell}

      Homebrew tells us that #{preferred} is your preferred shell,
      and your shell profile is at #{shell_profile.inspect}, if that helps 😇

      > btw, if you know how to make this process automated, help us out with a PR!
      > the code is here: https://github.com/Schniz/homebrew-tap/blob/master/Formula/fnm.rb
    EOS
  end

  test do
    system "#{bin}/fnm", "--version"
  end

  def source_for_shell
    if preferred == "fish"
      "fnm env --multi | source"
    else
      'eval "$(fnm env --multi)"'
    end
  end
end
