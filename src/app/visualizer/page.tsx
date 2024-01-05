import VisualizerWithSample from "@/components/visualizer-sample/visualizer-with-sample";
import { getFileString } from "@/utiles/getFileString";

import { terraformExamples } from "@/config/examples.config";

export default async function VisualizerSample({
  searchParams,
}: {
  searchParams: { filename: string };
}) {
  const filename = searchParams.filename;
  const fileString = await getFileString(
    terraformExamples.find((v) => v.filename === filename)?.src
  );

  return (
    <div>
      <VisualizerWithSample fileString={fileString} filename={filename} />
    </div>
  );
}
