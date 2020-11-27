class Dotty < Formula
  desc "The Scala 3 compiler, also known as Dotty."
  homepage "http://dotty.epfl.ch/"
  url "https://github.com/lampepfl/dotty/releases/download/3.0.0-M2/scala3-3.0.0-M2.tar.gz"
  sha256 "ec71104112749d0efdf1127f9c2ce9722f732181518be7e983a9f754a698c281"
  # mirror "https://www.scala-lang.org/files/archive/scala-2.12.2.tgz"
  version_scheme 1

  bottle :unneeded

  keg_only "because I want it so"

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install "bin", "lib"
  end

  test do
    # test dotc and dotr:
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]) = {
          println(s"${2 + 2}")
        }
      }
    EOS

    shell_output("#{bin}/scalac #{file}")
    out = shell_output("#{bin}/scala Test").strip

    assert_equal "4", out

    # test dotd:
    Dir.mkdir "#{testpath}/site"
    index_out = testpath/"site"/"index.md"
    index_out.write <<~EOS
    Hello, world!
    =============
    EOS
    shell_output("#{bin}/scalad -siteroot #{testpath}/site -project Hello #{file}")
    index_file = File.open("#{testpath}/site/_site/index.html", "rb").read
    assert index_file.include? '<h1><a href="#hello-world" id="hello-world">Hello, world!</a></h1>'
  end
end
