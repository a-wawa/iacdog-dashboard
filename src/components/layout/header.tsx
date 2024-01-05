"use client";

import classNames from "classnames";
import { usePathname } from "next/navigation";
import Link from "next/link";
import { project } from "@/config/project.config";
import { RiArrowDownDoubleFill } from "react-icons/ri";

const Header = () => {
  const pathname = usePathname();

  return (
    <div
      className={classNames(
        "w-full px-4 group grid grid-flow-row grid-cols-3 items-center top-0 left-0 z-50",
        pathname === "/visualizer"
          ? "hover:bg-white hover:bg-opacity-30 hover:shadow-md  h-3 fixed  z-10 bg-transparent hover:h-16 hover:backdrop-blur-lg transition-all "
          : "bg-white bg-opacity-70 h-16 shadow-md fixed backdrop-blur-lg backdrop-opacity-90 "
      )}
    >
      <div
        className={classNames(
          "fixed flex justify-center w-full ",
          pathname === "/visualizer"
            ? "top-[2px] opacity-100 group-hover:opacity-0 group-hover:-top-2 transition-all"
            : "-top-2 opacity-0"
        )}
      >
        <RiArrowDownDoubleFill />
      </div>
      <Link href={"/"} className="col-start-2 flex  justify-center">
        <h1
          className={classNames(
            "text-xl font-bold w-fit inline-block",
            pathname === "/visualizer"
              ? "opacity-0 group-hover:opacity-100 transition-all"
              : "opacity-100"
          )}
        >
          {project.logo}
        </h1>
      </Link>
      {pathname !== "/visualizer" && (
        <Link href={"/visualizer"} className="col-start-3 text-right">
          <button
            className={classNames(
              "text-sm aww-btn",
              pathname === "/visualizer"
                ? "opacity-0 group-hover:opacity-100 transition-all"
                : "opacity-100"
            )}
          >
            {project.title} 사용해보기
          </button>
        </Link>
      )}
    </div>
  );
};

export default Header;
