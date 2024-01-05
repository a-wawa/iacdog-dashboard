"use client";

import Image from "next/image";
import profilePic from "@/public/product/diagram1.png";
import { Tabs, TabList, Tab, TabPanel, TabPanels } from "@chakra-ui/react";
import { Prism as SyntaxHighlighter } from "react-syntax-highlighter";
import { xonokai as codeStyle } from "react-syntax-highlighter/dist/esm/styles/prism";
import { exampleCode } from "@/config/project.config";

const Section1 = () => {
  return (
    <div className="min-h-[500px] relative bg-white ">
      <div className="h-full w-full flex items-center justify-center ">
        <section className="max-w-[800px] w-full px-4 py-10 md:py-20 md:px-10 h-full">
          <Tabs variant="soft-rounded" colorScheme="orange">
            <TabList className=" justify-center">
              <Tab>Diagram</Tab>
              <Tab>Code</Tab>
            </TabList>
            <TabPanels>
              <TabPanel>
                <Image src={profilePic} alt="" />
              </TabPanel>
              <TabPanel>
                <div className="max-h-[500px] overflow-auto">
                  <SyntaxHighlighter
                    language="hcl"
                    style={codeStyle}
                    showLineNumbers
                  >
                    {exampleCode}
                  </SyntaxHighlighter>
                </div>
              </TabPanel>
            </TabPanels>
          </Tabs>

          <p className="mt-5 text-center text-lg lg:text-xl">
            자체 개발된 독자적인 알고리즘으로 테라폼 코드를 분석하여 <br />
            사용자 친화적인 시각화를 제공합니다.
          </p>
        </section>
      </div>
    </div>
  );
};

export default Section1;
