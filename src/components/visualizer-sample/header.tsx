import {
  CodeSampleCategory,
  codeSampleCategory,
} from "@/config/examples.config";
import { Box, HStack, Icon, Stack, VStack } from "@chakra-ui/react";
import { useState } from "react";
import SampleCodeItems from "./sample-code-items";
import SampleCategoryCheckBox from "./sample-category-checkbox";
import { Radio, RadioGroup } from "@chakra-ui/react";
import FileUploadInput from "../form/file-upload-input";
import useAWWStore from "@/store/AWWStore";
import { FiFile } from "react-icons/fi";
import { useRouter } from "next/navigation";

const LagacyRadio = () => {
  const isLagacy = useAWWStore((state) => state.isLagacy);
  const setIsLagacy = useAWWStore((state) => state.setIsLagacy);
  return (
    <Box w="full">
      <RadioGroup
        onChange={(v) => {
          if (setIsLagacy) {
            if (v === "sanbo") setIsLagacy(true);
            else setIsLagacy(false);
          }
        }}
        value={isLagacy ? "sanbo" : "new"}
      >
        <Stack direction="row">
          <Radio value="new" colorScheme="green">
            new
          </Radio>
          <Radio value="sanbo" colorScheme="yellow">
            sanbo
          </Radio>
        </Stack>
      </RadioGroup>
    </Box>
  );
};

const VisualizerHeader = () => {
  const [checked, setChecked] = useState<CodeSampleCategory[]>([
    ...codeSampleCategory,
  ]);

  const router = useRouter();

  return (
    <VStack py="5" w="100%" className="px-4 md:px-14">
      {/* <LagacyRadio  /> */}
      <HStack gap="3" justifyContent={"start"} w="100%" alignItems={"start"}>
        <VStack alignItems={"start"}>
          <SampleCategoryCheckBox checked={checked} setChecked={setChecked} />
          <FileUploadInput
            name="fileInputButton"
            acceptedFileTypes=".tf"
            noIcon
            InterfaceComponent={(props) => (
              <button
                {...props}
                className="aww-btn flex items-center justify-center gap-2 whitespace-nowrap"
                onClick={() => {
                  router.push("/visualizer");
                  if (props.onClick) props.onClick();
                }}
              >
                <FiFile />
                파일 업로드
              </button>
            )}
          />
        </VStack>
        <Box
          h="128px"
          flexGrow={"1"}
          p="3"
          rounded={"md"}
          border="1px solid"
          borderColor={"gray.200"}
          overflowY={"auto"}
        >
          <SampleCodeItems category={checked} />
        </Box>
      </HStack>
    </VStack>
  );
};

export default VisualizerHeader;
