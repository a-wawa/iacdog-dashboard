import Image from "next/image";
import image from "@/public/product/sidebar.png";
import { TbTools } from "react-icons/tb";
import { AiOutlineCode } from "react-icons/ai";
import { AiOutlineWarning } from "react-icons/ai";
import { AiOutlineBlock } from "react-icons/ai";
import { AiOutlineSetting } from "react-icons/ai";

interface CardProps {
  title: string;
  description: string;
  icon: JSX.Element;
}
const Card = ({ title, description, icon }: CardProps) => {
  return (
    <div className="bg-white text-base text-gray-800 p-4 rounded">
      <h3 className="font-bold text-orange-700 flex items-center justify-start gap-2">
        {icon}
        {title}
      </h3>
      <hr className="my-2" />
      <p>{description}</p>
    </div>
  );
};

const sidebars = [
  {
    title: "리소스 탭",
    description: "각 리소스의 상세 정보를 확인할 수 있습니다.",
    icon: <AiOutlineBlock />,
  },
  {
    title: "오류 탭",
    description: "시각화 과정에서 발생한 오류 목록을 표시 합니다.",
    icon: <AiOutlineWarning />,
  },
  {
    title: "코드 탭",
    description:
      "선택된 노드가 테라폼 코드의 어느 부분인지 확인 할 수 있습니다.",
    icon: <AiOutlineCode />,
  },
  {
    title: "설정 탭",
    description: "요약 노드, 개발자 모드 등을 통제하는 옵션을 제공합니다.",
    icon: <AiOutlineSetting />,
  },
];

const Section3 = () => {
  return (
    <div className="relative aww-bg-gradient ">
      <div className="h-full w-full flex items-center justify-center ">
        <section className=" w-full px-4 py-20 md:py-32 md:px-10 h-full">
          <div className="flex flex-col items-center gap-10">
            <div className="max-w-[800px]  shadow-lg ">
              <Image src={image} alt="" />
            </div>
            <div>
              <div className="text-5xl text-orange-100">
                <TbTools />
              </div>
              <p className=" max-w-[700px] mt-5  text-lg lg:text-xl">
                시각화된 인프라 구조도와 함께 다양한 기능의 사이드바를 활용할 수
                있습니다.
              </p>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-2 w-full max-w-[400px] md:max-w-[700px]  mt-10 mx-auto ">
                {sidebars.map((s) => (
                  <Card
                    key={s.title}
                    title={s.title}
                    description={s.description}
                    icon={s.icon}
                  />
                ))}
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
};
export default Section3;
