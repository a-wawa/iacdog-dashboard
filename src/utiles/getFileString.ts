import fs from "fs";

export async function getFileString(path?: string) {
  if (!path) return null;
  try {
    const post = fs
      .readFileSync(path)
      .toString();

    return post;
  } catch (err) {
    console.error("no file found", err);
    return null;
  }
}
