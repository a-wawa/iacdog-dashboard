import Image from "next/image";
import image from "@/public/product/diagram-summary.png";
import { HiSparkles } from "react-icons/hi2";

const Section2 = () => {
  return (
    <div className="relative bg-orange-100 ">
      <div className="h-full w-full flex items-center justify-center ">
        <section className=" w-full px-4 py-20 md:py-32 md:px-10 h-full">
          <div className="flex w-full h-full gap-20 md:gap-20 justify-center items-center flex-col md:flex-row">
            <div className="max-w-[300px] -skew-y-12 shadow-lg ">
              <Image src={image} alt="" />
            </div>
            <div>
              <div className="text-5xl text-orange-600">
                <HiSparkles />
              </div>
              <p className=" max-w-[500px] mt-5  text-lg lg:text-xl">
                각 노드 우측 상단의 버튼을 통해 복잡한 인프라 리소스 구성을
                빠르고 간편하게 파악할 수 있습니다.
              </p>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
};
export default Section2;
