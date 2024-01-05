import { VStack, Checkbox } from "@chakra-ui/react";
import { Dispatch, SetStateAction } from "react";
import {
  CodeSampleCategory,
  codeSampleCategory,
} from "@/config/examples.config";

interface VisualizerBodyProps {
  setChecked: Dispatch<SetStateAction<CodeSampleCategory[]>>;
  checked: CodeSampleCategory[];
}
const SampleCategoryCheckBox = ({
  checked: category,
  setChecked: setCategory,
}: VisualizerBodyProps) => {
  return (
    <VStack alignItems={"start"} spacing={0}>
      {codeSampleCategory.map((c) => (
        <Checkbox
          key={c}
          checked={category?.includes(c)}
          defaultChecked={category?.includes(c)}
          colorScheme="orange"
          onChange={(e) => {
            if (!e.target.checked)
              setCategory(
                category.filter((c_: CodeSampleCategory) => c_ !== c)
              );
            else setCategory([...category, c]);
          }}
        >
          {c}
        </Checkbox>
      ))}
    </VStack>
  );
};

export default SampleCategoryCheckBox;
