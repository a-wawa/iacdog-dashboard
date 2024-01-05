import "./globals.css";
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import { Providers } from "./providers";
import Header from "@/components/layout/header";
import Footer from "@/components/layout/footer";
import { project } from "@/config/project.config";
import Script from "next/script";
import { GoogleTagManager } from "@next/third-parties/google";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: project.title,
  description: "테라폼 시각화 프로젝트",
};

const GA_ID = "G-NE5CHXZT39";
const GTM_ID = "GTM-MMGNHXCX";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ko">
      <body suppressHydrationWarning={true}>
        <Providers>
          <Header />
          <div className="min-h-screen">{children}</div>
          <Footer />
        </Providers>
      </body>

      <GoogleTagManager gtmId={GTM_ID} />
    </html>
  );
}
