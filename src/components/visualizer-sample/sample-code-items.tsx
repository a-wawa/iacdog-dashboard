import {
  CodeSampleCategory,
  terraformExamples,
} from "@/config/examples.config";
import { Box, Flex } from "@chakra-ui/react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";

interface SampleCodesProps {
  category: CodeSampleCategory[];
}
const SampleCodeItems = ({ category }: SampleCodesProps) => {
  const items = terraformExamples.filter((v) =>
    category.includes(v.csp as CodeSampleCategory)
  );
  const filename = useSearchParams().get("filename");

  return (
    <Flex flexWrap={"wrap"} gap="2">
      {items.map((item) => (
        <Link
          key={item.src}
          href={{
            pathname: "/visualizer",
            query:
              filename === item.filename
                ? undefined
                : { filename: item.filename },
          }}
        >
          <Box
            px="4"
            py="2"
            as="button"
            rounded={"md"}
            key={item.src}
            bg={filename === item.filename ? "orange.500" : "orange.100"}
            color={filename === item.filename ? "white" : "gray.900"}
            cursor={"pointer"}
          >
            {item.filename}
          </Box>
        </Link>
      ))}
    </Flex>
  );
};

export default SampleCodeItems;
