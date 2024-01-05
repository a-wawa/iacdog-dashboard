"use client";
import { useVisualizerQuery } from "@/client/visualizer";
import {
  VisualizerContainer,
  ResourceTab,
  CodeTab,
  ErrorTab,
  SettingsTab,
  useVisualizerItem,
  useVisualizerData,
  useTooltip,
  useVisualizerView,
} from "@aww-vzc/react";
import { Block } from "@aww-vzc/simulator";
import { useEffect } from "react";
import Image from "next/image";

const VisualizerCaller = ({
  file,
  hash,
  isLagacy,
}: {
  file: File;
  hash: string;
  isLagacy?: boolean;
}) => {
  const res = useVisualizerQuery(file, hash, isLagacy);

  const { setError } = useVisualizerData();

  const { setSelectedItem, setHoverItem } = useVisualizerItem();
  const { setTooltipWithMouseEvent, setTooltipShow, setTooltipItem } =
    useTooltip();
  const { setSidebarShow } = useVisualizerView();

  useEffect(() => {
    setError([]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [file]);

  const handleMouseOver = (item: Block, e?: MouseEvent) => {
    setTooltipShow(true);
    setTooltipItem(item);
    setHoverItem(item);
  };

  const handleClick = (item: Block) => {
    setSidebarShow(true);
    setSelectedItem(item);
  };
  const handleMouseMove = (item: Block, e?: MouseEvent) => {
    if (e) setTooltipWithMouseEvent(e);
  };
  const handleMouseLeave = (item: Block) => {
    setTooltipShow(false);
    setHoverItem(null);
  };

  if (res.isLoading)
    return (
      <div className="w-screen h-full flex items-center justify-center flex-col gap-3">
        <div className="animate-ping">
          <Image
            src={`${
              process.env.NEXT_PUBLIC_BASE_PATH ?? ""
            }/logo/aww-removebg-fit.png`}
            width={498 / 10}
            height={410 / 10}
            alt=""
          />
        </div>
        <p className="mt-6">API 요청 중...</p>
      </div>
    );

  return (
    <div className="w-screen h-full">
      {document && (
        <VisualizerContainer
          useVisualizerRes={res}
          options={{
            // iconBasePath: import.meta.env.VITE_ICON_BASE_PATH,
            height: "100%",
            width: "100%",
            sidebar: {
              disable: false,
              defaultTab: ResourceTab.id,
              contents: [ResourceTab, ErrorTab, CodeTab, SettingsTab],
            },

            eventHandler: {
              mouseOver: {
                leaf: handleMouseOver,
                group: handleMouseOver,
                attachment: handleMouseOver,
                connection: handleMouseOver,
              },
              click: {
                leaf: handleClick,
                group: handleClick,
                attachment: handleClick,
                connection: handleClick,
              },
              mouseLeave: {
                leaf: handleMouseLeave,
                group: handleMouseLeave,
                attachment: handleMouseLeave,
                connection: handleMouseLeave,
              },
              mouseMove: {
                leaf: handleMouseMove,
                group: handleMouseMove,
                attachment: handleMouseMove,
                connection: handleMouseMove,
              },
            },
          }}
        />
      )}
    </div>
  );
};

export default VisualizerCaller;
