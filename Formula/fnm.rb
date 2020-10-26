# typed: false
# frozen_string_literal: true

# Fnm formula :D
class Fnm < Formula
  VERSION = "1.22.2"
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/releases/download/v#{VERSION}/fnm-macos.zip"
  sha256 "4136de871e4deb2d167d2cddcabdee0f9b21c0c6a639c9b7dba7ce451a9450b1"
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
      "fnm env --multi | source"
    else
      'eval "$(fnm env --multi)"'
    end
  end
end
