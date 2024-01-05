export function code2file(code?: string | null, filename?: string) {
  if (!document) return null;
  if (!code) return null;
  const blob = new Blob([code], { type: "text/plain" });
  const file_ = new File([blob], filename || "main.tf", {
    type: "text/plain",
  });
  return file_;
}

export function genFileBlob(fileString?: string, filename?: string) {
  const file = code2file(fileString, filename)
  return file
}