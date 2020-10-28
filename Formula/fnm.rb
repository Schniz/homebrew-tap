# typed: false
# frozen_string_literal: true

# Fnm formula :D
class Fnm < Formula
  VERSION = "1.22.3"
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/releases/download/v#{VERSION}/fnm-macos.zip"
  sha256 "b4826567c2df352eba9ccbcf667caa3d090b065b0c5187a7555a2817d1c18c6c"
  license "GPL-3.0-only"

  def install
    bin.install "fnm"

    (bin/"fnm").chmod 0555
    (bash_completion/"fnm").write `#{bin}/fnm completions --shell bash`
    (fish_completion/"fnm.fish").write `#{bin}/fnm completions --shell fish`
    (zsh_completion/"_fnm").write `#{bin}/fnm completions --shell zsh`
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

  test do
    system "#{bin}/fnm", "--version"
  end

  def source_for_shell
    if preferred == :fish
      "fnm env | source"
    else
      'eval "$(fnm env)"'
    end
  end
end
