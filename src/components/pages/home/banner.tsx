import classNames from "classnames";
import { project } from "@/config/project.config";
import { RiArrowDownDoubleFill } from "react-icons/ri";

const Circle = ({ className }: { className?: string }) => {
  return (
    <div
      className={classNames(
        "absolute rounded-full bg-white bg-opacity-30 backdrop-blur ",
        className ?? "w-80 h-80 "
      )}
    />
  );
};

const Banner = () => {
  return (
    <div className="h-screen min-h-[500px] relative overflow-hidden">
      <div className="h-full w-full absolute top-0 left-0 aww-bg-gradient" />
      <Circle className="-top-20 -left-20 w-80 h-80 blur-sm " />
      <Circle className="top-36 left-24 w-28 h-28 blur-[2px]" />
      <Circle className="top-0 right-10 w-40 h-40 " />
      <Circle className="-bottom-32 -right-32 w-96 h-96 blur-sm" />
      <Circle className="bottom-56 right-56 w-10 h-10 " />

      <div className="h-full w-full absolute flex items-center justify-center  text-gray-50 p-4 md:p-10">
        <div className="text-center h-fit w-fit ">
          <section>
            <h2 className="text-4xl lg:text-5xl font-bold mb-5">
              {project.slogan}
            </h2>
            <p className="mx-2 text-xl lg:text-2xl max-w-[800px]">
              {project.description}
            </p>
          </section>
        </div>
      </div>
      <div className="absolute bottom-10 right-1/2 text-lg text-white animate-bounce">
        <RiArrowDownDoubleFill />
      </div>
    </div>
  );
};

export default Banner;
