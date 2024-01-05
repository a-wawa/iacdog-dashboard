/* eslint-disable @next/next/no-img-element */
"use client";

import classNames from "classnames";
import { usePathname } from "next/navigation";
import Link from "next/link";
import Image from "next/image";

const Footer = () => {
  const pathname = usePathname();
  if (pathname == "/visualizer") return <></>;
  return (
    <div className="w-full px-4 md:px-32 py-8 bg-gray-100">
      <div className="flex items-center justify-start w-fit m-auto">
        <Image
          src={`${
            process.env.NEXT_PUBLIC_BASE_PATH ?? ""
          }/logo/aww-removebg-fit.png`}
          width={498 / 14}
          height={410 / 14}
          alt=""
        />
        <div className="ml-2 text-sm text-gray-600">
          © 2023 team A-wawa, All Rights Reserved
        </div>
      </div>
    </div>
  );
};

export default Footer;
