import { Box, Center, VStack } from "@chakra-ui/react";
import VisualizerCaller from "../visualizer-caller";
import md5 from "blueimp-md5";
import useAWWStore from "@/store/AWWStore";

const VisualizerBody = () => {
  const file = useAWWStore((state) => state.file);
  const fileString = useAWWStore((state) => state.fileString);
  const isLagacy = useAWWStore((state) => state.isLagacy);

  if (!file)
    return (
      <Center className="h-full text-center">
        <p className="mb-20">
          화면 상단에서 샘플 파일을 선택하거나 <br />
          파일을 업로드해보세요 🙂
        </p>
      </Center>
    );

  return (
    <VisualizerCaller
      file={file}
      hash={fileString ? md5(fileString) : file.name}
      isLagacy={isLagacy}
    />
  );
};

export default VisualizerBody;
