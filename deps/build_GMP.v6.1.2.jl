using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, String["libgmp"], :libgmp),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaMath/GMPBuilder/releases/download/v6.1.2-2"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, :glibc) => ("$bin_prefix/GMP.v6.1.2.aarch64-linux-gnu.tar.gz", "0312b4b24ce4e2042309518c05268a2d6efeb2d34e138e6f93d6decf75656d6d"),
    Linux(:aarch64, :musl) => ("$bin_prefix/GMP.v6.1.2.aarch64-linux-musl.tar.gz", "012c08b240e0072a8aac77f66a60005fe95905fb28bdb1ca30576ed83f38126f"),
    Linux(:armv7l, :glibc, :eabihf) => ("$bin_prefix/GMP.v6.1.2.arm-linux-gnueabihf.tar.gz", "59cedcce33d4475cba4d50e1fbadc6389b6fac071fb2d0510308a8b3906fa7c6"),
    Linux(:armv7l, :musl, :eabihf) => ("$bin_prefix/GMP.v6.1.2.arm-linux-musleabihf.tar.gz", "2abbc3ec12e27e8672537db2f46c8a7ad40a9b3558aa5281822e75734d64f41b"),
    Linux(:i686, :glibc) => ("$bin_prefix/GMP.v6.1.2.i686-linux-gnu.tar.gz", "0ff8173bc066e97fa73f932c54718fae857dd0252887ade5aa7ab39e2d619f23"),
    Linux(:i686, :musl) => ("$bin_prefix/GMP.v6.1.2.i686-linux-musl.tar.gz", "8bdd82625110b7536bbc5926418f3fd4a4800ea3c51deca6a644f9be2f768c3c"),
    Windows(:i686) => ("$bin_prefix/GMP.v6.1.2.i686-w64-mingw32.tar.gz", "e6ae903d4a7fd0e5854623ecde4ec76cbfe16aa8da164de113a4e088009537ac"),
    Linux(:powerpc64le, :glibc) => ("$bin_prefix/GMP.v6.1.2.powerpc64le-linux-gnu.tar.gz", "db1e745aafeedb4e97ca7dc9de3d1f1744bfda13be9c9be14b31c69db6e679ca"),
    MacOS(:x86_64) => ("$bin_prefix/GMP.v6.1.2.x86_64-apple-darwin14.tar.gz", "f1ecd085a34a384f03eb498d36b52f708d60ad291200f2f922bfd4ace0d002c8"),
    Linux(:x86_64, :glibc) => ("$bin_prefix/GMP.v6.1.2.x86_64-linux-gnu.tar.gz", "8c94f3402e0bb0f1653ecd4bedf9eb056ca7ad75728d750c6e54c9d7a6fcf637"),
    Linux(:x86_64, :musl) => ("$bin_prefix/GMP.v6.1.2.x86_64-linux-musl.tar.gz", "f47ae56ab12267f05bf11d8e9ce73171f116bb38197404bc9758393cb6828aa2"),
    FreeBSD(:x86_64) => ("$bin_prefix/GMP.v6.1.2.x86_64-unknown-freebsd11.1.tar.gz", "50d2cd4dd9d4ceeb64df7ad9db3c8c645c40dccad0078137d8042941b912f158"),
    Windows(:x86_64) => ("$bin_prefix/GMP.v6.1.2.x86_64-w64-mingw32.tar.gz", "58e15e26a02f51f9f00390ebef0566a1010860336a062fd6da17f7ba3fb55dd7"),
)
                    
# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end
                    
# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
