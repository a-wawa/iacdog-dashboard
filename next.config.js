/** @type {import('next').NextConfig} */

const nextConfig = {
  basePath: process.env.NEXT_PUBLIC_BASE_PATH || "",
  output: "standalone",
  async rewrites() {
    return [
      {
        source: `/assets/:path*`,
        destination: `${process.env.NEXT_PUBLIC_ICON_BASE_PATH}/assets/:path*`,
      },
    ];
  },
};

module.exports = nextConfig;
