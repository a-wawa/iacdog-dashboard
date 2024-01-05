"use client";

import { VStack } from "@chakra-ui/react";
import VisualizerHeader from "./header";
import VisualizerBody from "./body";
import { useEffect, useState } from "react";
import { genFileBlob } from "@/utiles/genFileBlob";
import useAWWStore from "@/store/AWWStore";

interface VisualizerWithSample {
  fileString?: string | null;
  filename?: string;
}

const VisualizerWithSample = ({
  fileString,
  filename,
}: VisualizerWithSample) => {
  const file = useAWWStore((state) => state.file);
  const setFile = useAWWStore((state) => state.setFile);
  const setFileString = useAWWStore((state) => state.setFileString);

  useEffect(() => {
    if (file?.name !== filename)
      setFile(genFileBlob(fileString || undefined, filename || undefined));
    setFileString(fileString || null);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fileString, filename]);

  return (
    <VStack gap="3" h="100vh">
      <VisualizerHeader />
      <VisualizerBody />
    </VStack>
  );
};

export default VisualizerWithSample;
