class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.36.orig.tar.gz"
  sha256 "7fe3cf3daf95ee93b47e568e85f4d341a1f9ae91766b4f9a9cdc29737dea4988"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20991a847ab51f210d5c91be35226e87657d3df7e6e73cc10855d2f89881cb29"
    sha256 cellar: :any,                 arm64_ventura:  "377efb661d6595713e9018799964562da2ffc4c46932683130f9c81831995def"
    sha256 cellar: :any,                 arm64_monterey: "aaff012a3b5ef26548e827b3d2793c3489ce7715b0c66452b2f750a0d76ca2c6"
    sha256 cellar: :any,                 sonoma:         "931c80e3e5133c4f6ed0de1a5cf6fa43bd78fb9c88129c606d95e07b5c6b1715"
    sha256 cellar: :any,                 ventura:        "aaeb651df301f4bda927f0c40e639187c5515e0d1d5d59148334545fc4f7ff4c"
    sha256 cellar: :any,                 monterey:       "99b1230055d0bf34057587970377321e9795af2024085c5881ff2558e838a96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f319cc0fd4acbf1508bfe5b8b73e878d04c0bee463eb05a4501ec3d2ebb0351b"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/17
  patch :p0 do
    # The MR has a typo, so we use MacPorts' version.
    url "https://raw.githubusercontent.com/macports/macports-ports/0ffd857cab7b021f9dbf2cbc876d8025b6aefeff/sysutils/fakeroot/files/patch-message.h.diff"
    sha256 "6540eef1c31ffb4ed636c1f4750ee668d2effdfe308d975d835aa518731c72dc"
  end

  def install
    system "./bootstrap" # remove when patches are no longer needed

    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
